-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION philips_contabil_pck.get_lote_revisao ( nr_lote_contabil_p lote_contabil.nr_lote_contabil%type) RETURNS varchar AS $body$
DECLARE


		qt_pendente_w 		bigint;
		qt_revisado_w 		bigint;
		qt_nao_revisado_w 	bigint;

		ie_return_w     	varchar(10);

		
BEGIN
	        select coalesce(ie_nao_revisado,ie_pendente,ie_revisado,'S')
	        into STRICT ie_return_w
	        from (SELECT (
	        		SELECT 'P' ie_pendente
	        		
	        		where exists (
	        			select 1
	        			from ctb_movimento a
	        			where nr_lote_contabil = nr_lote_contabil_p
	        			and a.ie_revisado = 'P'
	        			)
	        		) ie_pendente,
	        		(select 'S' ie_revisado
	        		
	        		where exists (
	        			select 1
	        			from ctb_movimento a
	        			where nr_lote_contabil = nr_lote_contabil_p
	        			and a.ie_revisado = 'S'
	        			)
	        		) ie_revisado,
	        		(select 'N' ie_nao_revisado
	        		
	        		where exists (
	        			select 1
	        			from ctb_movimento a
	        			where nr_lote_contabil = nr_lote_contabil_p
	        			and a.ie_revisado = 'N'
	        			)
	        		) ie_nao_revisado
	        	
	        	) alias7;

		return ie_return_w;

		END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION philips_contabil_pck.get_lote_revisao ( nr_lote_contabil_p lote_contabil.nr_lote_contabil%type) FROM PUBLIC;
