<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output omit-xml-declaration="yes" indent="yes"/>
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/domain/devices">

        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <xsl:element name="serial">
                <xsl:attribute name="type">pty</xsl:attribute>
            </xsl:element>
            <xsl:element name="channel">
                <xsl:attribute name="type">spicevmc</xsl:attribute>
                <xsl:element name="target">
                    <xsl:attribute name="type">virtio</xsl:attribute>
                    <xsl:attribute name="name">com.redhat.spice.0</xsl:attribute>
                    <xsl:attribute name="state">disconnected</xsl:attribute>
                </xsl:element>
                <xsl:element name="alias">
                    <xsl:attribute name="name">channel1</xsl:attribute>
                </xsl:element>
                <xsl:element name="address">
                    <xsl:attribute name="type">virtio-serial</xsl:attribute>
                    <xsl:attribute name="controller">0</xsl:attribute>
                    <xsl:attribute name="bus">0</xsl:attribute>
                    <xsl:attribute name="port">2</xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:copy>

    </xsl:template>

    <xsl:template match="/domain/devices/disk[@type='volume' and @device='disk' and driver[@name='qemu' and @type='qcow2']]/driver">
        <xsl:copy>
            <xsl:attribute name="discard">
                <xsl:value-of select="'unmap'" />
            </xsl:attribute>
            <xsl:attribute name="detect_zeroes">
                <xsl:value-of select="'unmap'" />
            </xsl:attribute>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>


</xsl:stylesheet>
