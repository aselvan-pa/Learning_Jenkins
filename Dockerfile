# use a node base image
FROM node:7-onbuild

# set labels
LABEL product="node"
LABEL team="node Team"
LABEL owner_email="node@paloaltonetworks.com"

# set a health check
HEALTHCHECK --interval=7s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:8000 || exit 1

# tell docker what port to expose
EXPOSE 8000
