
<!-- README.md is generated from README.Rmd. Please edit that file -->
predq
=====

This is an example of a shiny app for the USC IMAGE group. To run this app, besides of having `R` and `shiny`, you'll need to install the R package [`polygons`](https://github.com/USCBiostats/polygons), which is on development.

Shiny server in the Bioghost server
===================================

1.  To install

    ``` shell
    $ wget https://download3.rstudio.org/centos5.9/x86_64/shiny-server-1.5.5.872-rh5-x86_64.rpm
    $ sudo yum install --nogpgcheck shiny-server-1.5.5.872-rh5-x86_64.rpm
    ```

2.  You need to open the default port (which can be modified `/etc/shiny-server/shiny-server.conf`) as follows:

    ``` shell
    $ sudo firewall-cmd --zone=public --add-port=3838/tcp --permanent
    $ sudo firewall-cmd --reload
    ```

3.  To start/stop (more details [here](http://docs.rstudio.com/shiny-server/#upstart-ubuntu-12.04-through-14.10-redhat-6))

    ``` shell
    $ sudo /sbin/service shiny-server start
    $ sudo /sbin/service shiny-server stop
    ```

4.  Remember that you need to have `shiny` and `rmarkdown` installed and available as system wide (or to whatever user are you running the shiny app as, see the config file), otherwise it won't work!

5.  Once everything is in place, go to <http://bioghost.usc.edu:3838>. You can try running the hello example app following this webaddress <http://bioghost.usc.edu:3838/hello>

Shiny apps are hosted in `/srv/shiny-server/`
