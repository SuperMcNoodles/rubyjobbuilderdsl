## Create build flow style project

**dsl**

Description: Specify groovy DSL for a flow job

Multiple: Override

Example

    builder.flow 'hello_world-post' do
      dsl <<EOS
    build("hello_worl-" + params["GERRIT_BRANCH"],
     GERRIT_REFSPEC: "refs/heads/${params["GERRIT_BRANCH"]}",
     GERRIT_BRANCH: params["GERRIT_BRANCH"])
    EOS

    end