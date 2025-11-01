variable "rg_foundation" {
    description = <<EOF
    ** Foundation Parameters **

    ** location: Region where the resource group will be created
    ** environment: Resource group creation environment, e.g. dev, prod

EOF
type = object({
    location  = string
    environment = string
})
}

variable "resource_group" {
    description = <<EOF
    ** Resource Group Parameters **

    ** name: Free parameter that makes up the name of the resource Group

EOF
type = object({
    name = string
})
}



variable "tags" {
    description = "Tags to be applied to the resource group"
    type        = map(string)
    default     = {}
}