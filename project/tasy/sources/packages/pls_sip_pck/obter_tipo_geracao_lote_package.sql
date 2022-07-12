-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_sip_pck.obter_tipo_geracao_lote ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type, qt_vidas_operadora_p pls_lote_sip.qt_vidas_operadora%type default null) RETURNS varchar AS $body$
DECLARE


qt_vidas_operadora_w	pls_lote_sip.qt_vidas_operadora%type;
ie_tipo_geracao_w	varchar(30);


BEGIN
	
	if (coalesce(qt_vidas_operadora_p::text, '') = '') then

		select	coalesce(max(qt_vidas_operadora), 0)
		into STRICT	qt_vidas_operadora_w
		from	pls_lote_sip
		where	nr_sequencia	= nr_seq_lote_p;
	else
		qt_vidas_operadora_w	:= qt_vidas_operadora_p;
	end if;

	-- se a operadora tiver mais de 50.000 vidas, o SIP devera ser gerado por UF

	if (qt_vidas_operadora_w >= 50000) then

		ie_tipo_geracao_w := 'por_uf';
	else
		ie_tipo_geracao_w := 'sem_uf';
	end if;

	return ie_tipo_geracao_w;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_sip_pck.obter_tipo_geracao_lote ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type, qt_vidas_operadora_p pls_lote_sip.qt_vidas_operadora%type default null) FROM PUBLIC;
