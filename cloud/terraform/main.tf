provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

resource "oci_core_virtual_network" "lab_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "lab-vcn"
}

resource "oci_core_internet_gateway" "lab_igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.lab_vcn.id
  display_name   = "lab-igw"
}

resource "oci_core_subnet" "lab_subnet" {
  cidr_block                 = "10.0.1.0/24"
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_virtual_network.lab_vcn.id
  display_name               = "lab-subnet"
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_instance" "node1" {
  availability_domain = "Uocm:EU-FRANKFURT-1-AD-1"
  compartment_id      = var.compartment_ocid
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

  source_details {
    source_type = "image"
    source_id   = var.image_ocid
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.lab_subnet.id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
  }
}

resource "oci_core_instance" "node2" {
  availability_domain = "Uocm:EU-FRANKFURT-1-AD-1"
  compartment_id      = var.compartment_ocid
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

  source_details {
    source_type = "image"
    source_id   = var.image_ocid
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.lab_subnet.id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
  }
}
