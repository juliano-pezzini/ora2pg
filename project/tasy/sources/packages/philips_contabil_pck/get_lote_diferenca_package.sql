-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION philips_contabil_pck.get_lote_diferenca ( nr_lote_contabil_p lote_contabil.nr_lote_contabil%type) RETURNS varchar AS $body$
DECLARE


		vl_debito_w     ctb_movimento.vl_movimento%type;
		vl_credito_w    ctb_movimento.vl_movimento%type;

		ie_return_w     varchar(1);

		
BEGIN
	        select  coalesce(sum(x.vl_debito),0) vl_debito,
	                coalesce(sum(x.vl_credito),0) vl_credito
	        into STRICT    vl_debito_w,
	                vl_credito_w
	        from (
	            SELECT  sum(a.vl_movimento) vl_debito,
	                    0 vl_credito
	            from    ctb_movimento a
	            where   a.nr_lote_contabil = nr_lote_contabil_p
	            and     (a.cd_conta_debito IS NOT NULL AND a.cd_conta_debito::text <> '')
	            and     coalesce(a.cd_conta_credito::text, '') = ''
	
union all

	            SELECT  0 vl_debito,
	                    sum(a.vl_movimento) vl_credito
	            from    ctb_movimento a
	            where   a.nr_lote_contabil = nr_lote_contabil_p
	            and     (a.cd_conta_credito IS NOT NULL AND a.cd_conta_credito::text <> '')
	            and     coalesce(a.cd_conta_debito::text, '') = ''
	            
union all

	            select  sum(a.vl_movimento) vl_debito,
	                    sum(a.vl_movimento) vl_credito
	            from    ctb_movimento a
	            where   a.nr_lote_contabil = nr_lote_contabil_p
	            and     (a.cd_conta_credito IS NOT NULL AND a.cd_conta_credito::text <> '')
	            and     (a.cd_conta_debito IS NOT NULL AND a.cd_conta_debito::text <> '')
	        ) x;

	        if (vl_debito_w <> vl_credito_w) then
	        	ie_return_w := 'S';
	        else
	        	ie_return_w := 'N';
	        end if;

		return ie_return_w;

		END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION philips_contabil_pck.get_lote_diferenca ( nr_lote_contabil_p lote_contabil.nr_lote_contabil%type) FROM PUBLIC;
