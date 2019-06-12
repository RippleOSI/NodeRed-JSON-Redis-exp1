# Node Red Project for Medical API

## Project Description
Node-RED is a programming tool for wiring together hardware devices, APIs and online services in new and interesting ways. The light-weight runtime is built on Node.js, taking full advantage of its event-driven, non-blocking model.
This project is designed for several APIs storing and retrieving various medical data.
The medical data is stored in Redis database which is the fastest database now.
This project is well-designed, easy to maintain and extend and well-documented as well.

## Installation Guide
- Run Docker Image
  - docker build -t nodered-redis .
  - docker run --name mynodered nodered-redis
  - docker inspect -f "{{ .NetworkSettings.IPAddress }}" mynodered
  - Open your browser and enter URL with docker's IP address and port 1880.
- Import flows from JSON file and deploy it.
- Enjoy your API

## Overview of Approach

![NodeRed flow](/img/NodeRed_JSONata_Redis_exp1.PNG)


## Nodes Description in the flow
```
    Type                   Name                                         Description
    
    Http        [post] /patient/:ptId/allergies     For API post requests. You can simply add new API
                                                    routes for POST by adding this node and change the
                                                    URL property of the node.

    Http        [get] /patient/:ptId/allergies      For API get requests. You can simply add new API
                                                    routes for GET by adding this node and change the
                                                    URL property of the node.

    Change              PostParams                  This node accepts POST request parameters and
                                                    convert the datatype so that it can be used
                                                    for storing data in the redis database.
                                                    You have to add this node as well as  Http node when 
                                                    you add new API routes for POST. And then configure
                                                    the node using JSONata. Have a look at existing node
                                                    and get some ideas for configuring the node.

    Change              GetParams                   This node is almost same as PostParams node. It just
                                                    change datatype so that it can be used for retrieving
                                                    data from redis.

    Function         Redis HSET params              This node generates data for HSET command in redis. 
                                                    Return an array of parameters for HSET command. 
                                                    HSET command requires three parameters in array form.
                                                    [key, field, value]

    Function         Redis HGET params              This node generates data for HGET command in redis.
                                                    Return an array of parameters for HGET command.
                                                    HGET command requires two parameters in array form.
                                                    [key, field]

    Function         Transform method               This node extracts transform value from request query
                                                    parameters. It is used for transform of JSON data.

    Redis cmd           Redis hset                  Executes the HSET command in redis.
                                                    Have a look at node configuration.

    Redis cmd           Redis hget                  Executes the HGET command in redis.
                                                    Have a look at node configuration.

    Function            Result JSON                 JSON data for response when API Post request is successed.

  Http response        Post Success                 Makes an HTTP response with success info.

    Switch              switch                      Switch node for checking HGET result from redis.
                                                    If the return value is null, make a HTTP response promptly.
                                                    Otherwise, response with JSON data.

  Http response         GET No Data                 Makes an HTTP response with string 'null'

     JSON              Database JSON                The HGET result is string for JSON data.
                                                    We change the string to a JSON object using this node.

     JOIN           Add transform method            This node joins two objects, one is JSON object from database
                                                    and another one has transform method.

    Switch            Transform Switch              This switch is used for checking transform type. You can add
                                                    more transform type by editing this node.
                                                    Have a look at node configuration and get some idea.

    Change         TransformA-Allergy-UI2openEHR    These node apply transform to the JSON object retrieved
                                                    from database. If you want to add new transform,
                    TransformB-Allergy-UI2FHIR      add another node which is similar to this one
                                                    and configure the node. You can get idea for configuration
                                                    by looking at current configuration.

    Function            No Transform                This node removes transform property from JSON object.
                                                    This is needless for our results.

  Http response         GET success                 Makes an HTTP response with final result.
```
