-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_sip_pck.obter_se_item_gerado ( nr_seq_lote_sip_p pls_lote_sip.nr_sequencia%type, nr_seq_item_assist_p sip_item_assistencial.nr_sequencia%type, ie_tipo_contratacao_p sip_lote_item_assistencial.ie_tipo_contratacao%type, ie_segmentacao_p sip_lote_item_assistencial.ie_segmentacao_sip%type, sg_uf_p sip_lote_item_assistencial.sg_uf%type) RETURNS boolean AS $body$
DECLARE

qt_registro_w	integer;


BEGIN

	select	count(1)
	into STRICT	qt_registro_w
	from	sip_lote_item_assistencial
	where	nr_seq_lote		= nr_seq_lote_sip_p
	and	nr_seq_item_sip		= nr_seq_item_assist_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_p
	and	ie_segmentacao_sip	= ie_segmentacao_p
	and	sg_uf			= sg_uf_p;

	if (qt_registro_w > 0) then
	
		return true;
	else
		return false;
	end if;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_sip_pck.obter_se_item_gerado ( nr_seq_lote_sip_p pls_lote_sip.nr_sequencia%type, nr_seq_item_assist_p sip_item_assistencial.nr_sequencia%type, ie_tipo_contratacao_p sip_lote_item_assistencial.ie_tipo_contratacao%type, ie_segmentacao_p sip_lote_item_assistencial.ie_segmentacao_sip%type, sg_uf_p sip_lote_item_assistencial.sg_uf%type) FROM PUBLIC;