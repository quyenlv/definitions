<?xml version="1.0" encoding="UTF-8"?>

<!--
########### SVN repository information ###################
# $Date$
# $Author$
# $Revision$
# $HeadURL$
# $Id$
########### SVN repository information ###################

Purpose:
	This stylesheet is used to translate the NeXus Definition Language
	specifications into XML Schema (.xsd) files for use in
	validating candidate NeXus data files and also in preparing
	additional application definitions and XML schemas for use by NeXus.

Usage:
	xsltproc nxdl2xsd.xsl $(NX_CLASS).nxdl > $(NX_CLASS).xsd
-->

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:nx="http://definition.nexusformat.org/schema/3.1"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"/>

    <xsl:template match="/">

<xsl:comment>#########################################################
######	 This xsd file was auto-generated from an NXDL file by an XSLT transformation.  ######
######	 Do NOT edit this XML Schema file.						######
#########################################################</xsl:comment>

        <xsl:element name="xs:schema">
            <xsl:attribute name="nx:xslt_name">nxdl2xsd.xsl</xsl:attribute>
            <xsl:attribute name="nx:xslt_id">$Id$</xsl:attribute>
            <!-- XSLT v2.0 feature: <xsl:attribute name="nx:xsd_created"><xsl:value-of select="fn:current-dateTime()" /></xsl:attribute>-->
            <xsl:attribute name="targetNamespace">http://definition.nexusformat.org/schema/3.1</xsl:attribute>
            <!--<xsl:attribute name="elementFormDefault">qualified</xsl:attribute>-->
            <!--<xsl:attribute name="attributeFormDefault">qualified</xsl:attribute>-->
            <!-- special case for nx:attribute elements because they have to come before documentation -->
            <xsl:for-each select="nx:attribute">
                <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
                <xsl:apply-templates select="*"/>
            </xsl:for-each>
            <xsl:element name="xs:annotation">
                <xsl:element name="xs:documentation"><!-- NeXus license comes next -->
# NeXus - Neutron, X-ray, and Muon Science Common Data Format
# 
# Copyright (C) 2008 NeXus International Advisory Committee (NIAC)
# 
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# For further information, see http://www.nexusformat.org
                </xsl:element>
            </xsl:element>
		    <xsl:apply-templates select="nx:definition"/>
		</xsl:element>
    </xsl:template>
    
    <xsl:template match="nx:definition">
        <!-- extends from this NeXus object -->
        <xsl:element name="xs:include">
            <!-- add special case condition for NXobject (should really convert all NXDL to use the proper base class) -->
            <xsl:attribute name="schemaLocation"><xsl:value-of select="@extends"/>.xsd</xsl:attribute>
            <xsl:call-template name="comment">
                <xsl:with-param name="msg"><xsl:value-of select="name()"/> declaration: <xsl:value-of select="@name"/></xsl:with-param>
            </xsl:call-template>
            <xsl:element name="xs:annotation">
                <xsl:element name="xs:documentation">NXDL "<xsl:value-of select="@name"/>" extends the <xsl:value-of select="@extends"/> class</xsl:element>
            </xsl:element>
        </xsl:element>
        <!-- calls these NeXus or application objects -->
        <xsl:call-template name="comment">
            <xsl:with-param name="msg">other objects used by this NXDL</xsl:with-param>
        </xsl:call-template>
        <xsl:for-each select="nx:group">
            <xsl:element name="xs:include">
                <xsl:attribute name="schemaLocation"><xsl:value-of select="@type"/>.xsd</xsl:attribute>
                <xsl:element name="xs:annotation">
                    <xsl:element name="xs:documentation">type="<xsl:value-of select="@type"/>" from a group element in the NXDL</xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
        <!-- elements that define this object -->
        <xsl:call-template name="comment">
            <xsl:with-param name="msg">declarations (attributes, docs, groups, and fields)</xsl:with-param>
        </xsl:call-template>
        <xsl:element name="xs:complexType">
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:element name="xs:sequence">
                <xsl:apply-templates select="*"/>
            </xsl:element>
            <xsl:element name="xs:attribute">
                <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                <xsl:attribute name="use">optional</xsl:attribute>
            </xsl:element>
            <xsl:if test="count(nx:attribute)>0">
                <!-- special case: need to handle nx:attribute _after_ the sequence! -->
                <xsl:for-each select="nx:attribute">
                    <xsl:element name="xs:attribute">
                        <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                        <xsl:apply-templates select="@*"/>
                        <xsl:choose>
                            <xsl:when test="count(nx:enumeration)>0"><xsl:apply-templates select="nx:enumeration"/></xsl:when>
                            <xsl:otherwise><xsl:apply-templates select="*"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:for-each>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    
    <!-- nx:doc is complete -->
    <xsl:template match="nx:docXX" />
    <xsl:template match="nx:doc">
        <!-- documentation -->
        <xsl:element name="xs:annotation">
            <xsl:element name="xs:documentation"><xsl:value-of select="."/></xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="nx:field">
        <!-- named element declaration -->
        <xsl:element name="xs:element">
            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
            <xsl:call-template name="comment">
                <xsl:with-param name="msg"><xsl:value-of select="name()"/> declaration: <xsl:value-of select="@name"/></xsl:with-param>
            </xsl:call-template>
            <!-- documentation comes before the sequence -->
            <xsl:apply-templates select="nx:doc"/>
            <xsl:choose>
                <xsl:when test="count(nx:enumeration)>0">
                    <xsl:apply-templates select="nx:enumeration"/>
                </xsl:when>
                <xsl:otherwise><!-- no nx:enumeration -->
                    <xsl:element name="xs:complexType">
                        <xsl:element name="xs:simpleContent">
                            <xsl:element name="xs:extension">
                                <!-- @name is handled already -->
                                <xsl:call-template name="typeAttributeDefaultHandler" >
                                    <!-- handle @type attribute -->
                                    <xsl:with-param name="item">base</xsl:with-param>
                                </xsl:call-template>
                                <!-- dimensions declaration -->
                                <xsl:if test="nx:dimensions!=''">
                                    <xsl:element name="xs:attribute">
                                        <xsl:attribute name="name">dimensions</xsl:attribute>
                                        <xsl:call-template name="typeAttributeDefaultHandler" >
                                            <xsl:with-param name="item">type</xsl:with-param>
                                        </xsl:call-template>
                                        <xsl:apply-templates select="nx:dimensions/nx:doc"/>
                                    </xsl:element>
                                </xsl:if>
                                <!-- special case for nx:attribute elements 
                                    because they have to come before documentation -->
                                <xsl:for-each select="nx:attribute">
                                    <xsl:element name="xs:attribute">
                                        <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                                        <xsl:if test="count(nx:enumeration)=0">
                                            <xsl:call-template name="typeAttributeDefaultHandler" >
                                                <xsl:with-param name="item">type</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:apply-templates select="*"/>
                                    </xsl:element>
                                </xsl:for-each>
                                <!-- process any sub-elements -->
                                <xsl:for-each select="*">
                                    <xsl:if test="name()!='doc'">
                                        <xsl:apply-templates select="."/>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:element><!-- xs:extension -->
                        </xsl:element><!-- xs:simpleContent -->
                    </xsl:element><!-- xs:complexType -->
                </xsl:otherwise><!-- no nx:enumeration -->
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="nx:group">
        <!-- reference to another NX object (requires that object's XSD) -->
        <xsl:call-template name="comment">
            <xsl:with-param name="msg">group declaration</xsl:with-param>
        </xsl:call-template>
        <xsl:element name="xs:element">
            <xsl:attribute name="name"><xsl:value-of select="@type"/></xsl:attribute>
            <xsl:choose>
                <xsl:when test="count(nx:field)+count(nx:group)>0">
                    <!-- if there are fields or groups, then documentation comes afterwards -->
                    <xsl:apply-templates select="nx:doc"/>
                    <!-- fields or groups within this group element  -->
                    <xsl:comment> this is part of an <xsl:value-of select="@type"/> object </xsl:comment>
                    <xsl:element name="xs:complexType">
                        <xsl:element name="xs:sequence">
                            <xsl:apply-templates select="nx:field|nx:group"/>
                        </xsl:element>
                        <xsl:if test="count(@name)>0">
                            <xsl:element name="xs:attribute">
                                <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="count(@name)>0">
                    <xsl:attribute name="type">nx:<xsl:value-of select="@type"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <!-- no fields or groups within this group element -->
                    <xsl:call-template name="typeAttributeDefaultHandler" >
                        <xsl:with-param name="item">type</xsl:with-param>
                    </xsl:call-template>
                    <xsl:apply-templates select="nx:doc"/>
                    <!--<xsl:comment> - - - no fields or groups below this point - - - </xsl:comment>-->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@units">
        <xsl:attribute name="{name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="nx:enumeration">
        <!--<xsl:call-template name="comment">
            <xsl:with-param name="msg"><xsl:value-of select="name()"/> declaration</xsl:with-param>
            </xsl:call-template>-->
        <xsl:element name="xs:simpleType">
            <xsl:element name="xs:restriction">
                <xsl:attribute name="base">
                    <xsl:choose>
                        <!-- specified --><xsl:when test="count(@type)>0">nx:<xsl:value-of select="@type"/></xsl:when>
                        <!-- default --><xsl:otherwise>nx:NX_CHAR</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:apply-templates select="nx:item"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="nx:item">
        <xsl:element name="xs:enumeration">
            <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="comment">
        <xsl:param name="msg"/>
        <!-- put a comment into the XSD (usually before every declaration) -->
        <xsl:comment>+++++ <xsl:value-of select="$msg"/> +++++</xsl:comment>
    </xsl:template>
    
    <xsl:template name="typeAttributeDefaultHandler">
        <xsl:param name="item"/>
        <xsl:attribute name="{$item}">
            <xsl:choose>
                <!-- default --><xsl:when test="count(@type)=0">nx:NX_CHAR</xsl:when>
                <!-- present --><xsl:otherwise>nx:<xsl:value-of select="@type"/></xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    
    <!--leave these templates empty, they are handled by special case code as needed	-->
    <xsl:template match="nx:attribute"/>
    <xsl:template match="nx:dimensions"/>
    <xsl:template match="@name"/>
    <xsl:template match="@type"/>
    
</xsl:stylesheet>