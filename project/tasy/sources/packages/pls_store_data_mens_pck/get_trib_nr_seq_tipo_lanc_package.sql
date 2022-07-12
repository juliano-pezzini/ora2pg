-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_store_data_mens_pck.get_trib_nr_seq_tipo_lanc () RETURNS bigint AS $body$
BEGIN
		return current_setting('pls_store_data_mens_pck.nr_seq_tipo_lanc_trib_w')::pls_mensalidade_seg_item.nr_seq_tipo_lanc%type;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_store_data_mens_pck.get_trib_nr_seq_tipo_lanc () FROM PUBLIC;
