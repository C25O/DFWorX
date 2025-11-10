# Coolify MCP API Reference

Below is the complete reference for the Coolify MCP API, which includes all available resources, requests, responses, and parameters. Provided in `TOON` format.

```
Resources[9]{id,resources,requests,responses,parameters}:
1,list-resources,list-resources,list-of-all-resources-in-coolify,na
2,list-applications,list-applications,list-of-all-applications,na
3,get-application-details,get-application,details-of-the-specified-application,{"uuid":"<application-uuid>"}
4,start-application,start-application,result-of-the-start-operation,{"uuid":"<application-uuid>"}
5,stop-application,stop-application,result-of-the-stop-operation,{"uuid":"<application-uuid>"}
6,restart-application,restart-application,result-of-the-restart-operation,{"uuid":"<application-uuid>"}
7,deploy-application,deploy,result-of-the-deploy-operation,{"uuid":"<application-uuid>"}
8,get-version,get-version,current-version-of-the-coolify-api,na
9,health-check,health-check,system-health-status,na
````
---

> **TOON Format**
> *Token-Oriented Object Notation is a compact, human-readable serialization format designed for passing structured data to Large Language Models with significantly reduced token usage. It's intended for LLM input as a lossless, drop-in representation of JSON data.*

