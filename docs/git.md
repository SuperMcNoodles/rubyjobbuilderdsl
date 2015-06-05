## Configure Git SCM

**git**

Description: Configure Git version as SCM

Multiple: Override

Example

    builder.freestyle 'hello_world-master' do
      git do
        url 'ssh://builduser@gerrit.acme.com:29418/hello_world'
        basedir 'hello_world'
        reference_repo '$HOME/hello_world.git'
        branches '$GERRIT_BRANCH'
        refspec '$GERRIT_REFSPEC'
        choosing_strategy 'gerrit'
        git_config_name 'foo'
        git_config_email 'foo@acme.com'
      end
    end

**jgit**

Description: Configure Git version as SCM using jgit. Credentials must be created with the specified id using groovy script

Multiple: Override

Example

    builder.freestyle 'hello_world-master' do
      git do
        url 'ssh://builduser@gerrit.acme.com:29418/hello_world'
        basedir 'hello_world'
        reference_repo '$HOME/hello_world.git'
        branches '$GERRIT_BRANCH'
        refspec '$GERRIT_REFSPEC'
        choosing_strategy 'gerrit'
        git_config_name 'foo'
        git_config_email 'foo@acme.com'
        jgit
        credentials 'foo'
      end
    end

Example of creating credentials

    import jenkins.model.*
    import hudson.plugins.sshslaves.*
    import com.cloudbees.plugins.credentials.*
    import com.cloudbees.plugins.credentials.common.*
    import com.cloudbees.plugins.credentials.domains.*
    import com.cloudbees.jenkins.plugins.sshcredentials.impl.*

    domain = Domain.global()
    store = Jenkins.instance.getExtensionList(
      'com.cloudbees.plugins.credentials.SystemCredentialsProvider'
    )[0].getStore()

    username = credentialsId = 'foo'
    passphrase = description = null

    privateKey = """
    -----BEGIN RSA PRIVATE KEY-----
    MIIEoQIBAAKCAQEAyTsKNPUc4GkfZjNlLmLpuS+wecpCQOJs7MubPoNGk5F0cK4Q
    ...
    -----END RSA PRIVATE KEY-----
    """

    credentials = new BasicSSHUserPrivateKey(
      CredentialsScope.GLOBAL,
      credentialsId,
      username,
      new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(privateKey),
      passphrase,
      description
    )

    existing = store.getCredentials(domain).find { it.id == credentialsId }
    if (existing) {
      println "removing ${credentialsId}"
      store.removeCredentials(domain, existing)
    }

    println "adding ${credentialsId}"
    store.addCredentials(domain, credentials)

