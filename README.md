# pds-tf

via [@jaronoff97](/jaronoff97/pds-tf/) and [@lizthegrey](/lizthegrey).

## Introduction

This [opentofu](https://opentofu.org) / [terraform](https://www.hashicorp.com) example configures a Bluesky PDS.

Please read the [pds](https://github.com/bluesky-social/pds) documentation first.

**Running this IaC may involve you being billed by AWS**. 

You **will** need to handle the DNS configuration separately - this IaC is **only** for the AWS part of the pds setup.

## What you will need:

You will **need** to edit `variables.tf` to specific your pds name / admin email address.

You will will need to prove an SSH public key and an AWS region and availability zone - see [here](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/) for the AWS list.

