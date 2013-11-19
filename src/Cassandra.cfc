/* The MIT License (MIT)
 * 
 * Copyright (c) 2013 Jesse Shaffer
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/**
 * Cassandra - a wrapper library for the Astyanax API
 * 
 * @author jesse.shaffer
 * @license MIT (http://opensource.org/license/MIT)
 * @date 11/15/13
 **/
component accessors=true output=false persistent=false {
	
	property Factory;
	property string CassandraVersion default="2.0.2";
	property string CQLVersion default="3.0.0";
	
	/**
	 * Constructor
	 **/
	public function init() {
		this.setFactory(new factory.Astyanax());
	}
	
	/**
	 * Gets a connection builder in order to connect using more than the standard connection information.
	 **/
	public function getConnectionBuilder() {
		return this.getFactory().createResolved("AstyanaxContext$Builder");
	}
	
	/**
	 * Opens a connection pool to a single host.
	 * @host				 The hostname/ip address of a seed node.
	 * @clusterName			 The name of the cluster to use connect to 
	 * @keyspaceName		 The name of the keyspace to connect to (not required if you just need information about the cluster)
	 * @port				 The port that <host> is listening on for Thrift connections
	 * @connectionsPerHost	 How many open connections will this pool service?
	 * @nodeDiscoveryType	 How are nodes discovered on the network. See http://stackoverflow.com/questions/16453411/nodediscoverytype-as-token-aware-in-astyanax-client
	 * @connPoolType		 How the connection pool determines which host to connect to. See http://stackoverflow.com/questions/16453411/nodediscoverytype-as-token-aware-in-astyanax-client
	 **/
	public function quickConnect(required	string	host
								,required	string	clusterName
								,			string	keyspaceName		= ""
								,			numeric	port				= 9160
								,			numeric	connectionsPerHost	= 20
								,			string	nodeDiscoveryType	= "RING_DESCRIBE"
								,			string	connPoolType		= "TOKEN_AWARE"
					) {
		
		nodeDiscoveryType	= this.getFactory().createResolved("connectionpool.NodeDiscoveryType")[nodeDiscoveryType];
		connPoolType		= this.getFactory().createResolved("connectionpool.impl.ConnectionPoolType")[connPoolType];
		
		/* create builder for a cluster */
		var context	= this.getConnectionBuilder()
						.forCluster(arguments.clusterName);
		
		/* if a keyspace is specified, add it to the context */
		if (len(arguments.keyspaceName))
			context=context.forKeyspace(arguments.keyspaceName);
		
		/* add connection pool information (for single host) */
		var connPoolName = "CS-QC-#arguments.host#:#arguments.clusterName#:#arguments.keyspaceName#";
		context		= context.withConnectionPoolConfiguration(this.getFactory().new_connectionpool$impl$ConnectionPoolConfigurationImpl(connPoolName)
							.setPort(port)
							.setMaxConnsPerHost(connectionsPerHost)
							.setSeeds("#arguments.host#:#arguments.port#")
						)
		/* enable CQL, and set other connection configurations */
						.withAstyanaxConfiguration(this.getFactory().new_impl$AstyanaxConfigurationImpl()	  
							.setCqlVersion("3.0.0")
							.setTargetCassandraVersion("2.0.2")
							.setDiscoveryType(nodeDiscoveryType)
							.setConnectionPoolType(connPoolType)
						)
		/* add a connection pool monitor */
						.withConnectionPoolMonitor(this.getFactory().createResolved("connectionpool.impl.CountingConnectionPoolMonitor"))
						;
		
		/* build the context for either a keyspace or cluster */
		var tff = this.getFactory().createResolved("thrift.ThriftFamilyFactory").getInstance();
		context = len(arguments.keyspaceName)	? context.buildKeyspace(tff)
													: context.buildCluster(tff); 
		
		/* open the connection and return to requestor */
		context.start();
		return context;
	}
	
}