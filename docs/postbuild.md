## Configure post build activities

**allow_broken_build_claiming**

Description: Allow developer to claim for broken build

Multiple: Override

Example

    builder.freestyle 'hello_world-build' do
     postbuild do
       allow_broken_build_claiming
     end
    end

**archive**

Description: Archive artifacts

Multiple: Override

Example

    builder.freestyle 'hello_world-master' do
      postbuild do
        archive do
          file 'package/**',
             'output/**',
             'dependencies/lib/**'
          latest_only true
        end
      end
    end

**chucknorris**

Description: Show Chuck Norris Image

Multiple: Override

Example

    builder.freestyle 'hello_world-build' do
      postbuild do
        chucknorris
      end
    end

**game**

Description: Enable CI Game

Multiple: Override

Example

    builder.freestyle 'hello_world-build' do
      postbuild do
        game
      end
    end

**groovy**

Description: Run groovy script

Multiple: Override

Example

    builder.freestyle 'hello_world-build' do
      postbuild do
        groovy <<EOS
    def logger = manager.listener.logger
    logger.println("--- Hello World")
    EOS
      end
    end

**logparser**

Description: Parse console log to highlight errors

Multiple: Override

Example

    builder.freestyle 'hello_world-build' do
      postbuild do
        logparser '/var/lib/jenkins/build_parsing_rules' do
          fail_on_error
        end
      end
    end

**pubish_pmd**

Description: Publish PMD analysis

Multiple: Override

Example

    builder.freestyle 'hello_world' do
      postbuild do
        publish_pmd do
          pmd_results 'build/phppmd.txt'
        end
      end
    end

**publish_cloverphp**

Description: Publish clover php analysis

Multiple: Override

Example

    builder.freestyle 'hello_world' do
      postbuild do
        publish_cloverphp do
          xml_location 'build/coverage_clover.xml'
          html_report_dir 'build/coverage'
          healthy_target :method => 70, :statement => 80
        end
      end
    end

**publish_html**

Description: Publish html report

Multiple: Override

Example

    builder.freestyle 'hello_world-servicetest' do
      postbuild do
        publish_html 'Test Report' do
          dir '$BUILD_NUMBER\\Reports'
          file 'test-report.html'
          keep_all false
          allow_missing true
        end
      end
    end

**publish_javadoc**

Description: Publish javadoc

Multiple: Override

Example

    builder.freestyle 'hello_world-build' do
      postbuild do
        publish_javadoc do
          doc_dir 'build/doc'
          keep_all
        end
       end
    end

**publish_nunit_report**

Description: Publish NUnit test results.

Multiple: Override

Example

    builder.freestyle 'hello_world-build' do
      postbuild do
        publish_nunit_report 'foo\\bar\\*.xml'
      end
    end

**publish_tap**

Description: Publish TAP test result

Multiple: Override

Example

    builder.freestyle 'hello_world-build' do
      postbuild do
        publish_tap 'TestResultsInTapFormat.tap' do
          verbose true
          require_plan true
        end
      end
    end

**publish_xunit_report**

Description: Publish XUnit test results

Multiple: Override

Example

    builder.freestyle 'hello_world-build' do
      postbuild do
        publish_xunit_report 'foo\\bar\\*.xml' do
          failed_threshold :total_failed_tests => 0, :new_failed_tests => 0
          unstable_threshold :total_skipped_tests => 0, :new_skipped_tests => 0
        end
      end
    end

**send_email**

Description: Send notification via email

Multiple: Override

Example

    builder.freestyle 'hello_world-build' do
      postbuild do
        send_email 'test@example.com' do
          notify_every_unstable_build false
          send_to_individuals true
        end
      end
    end

**shell**

Description: Run shell command in as a post build action

Multiple: Override

Example

    builder.freestyle 'hello_world-build' do
      postbuild do
        shell 'cd Reports && mv $(ls *.xml) merge.xml'
      end
    end

**trigger**

Description: Trigger other job when this build succeeds

Multiple: Override

Example

    builder.freestyle 'hello_world-build' do
      postbuild do
        trigger 'foo-build', 'bar-build' do
          fail_on_missing true
          current_parameters true
          file 'env.properties'
          predefined_parameters 'BUILD_NUM' => '${BUILD_NUMBER}',
                                'PACKAGE_VERSION' => '${PACKAGE_VERSION}'
        end
      end
    end


