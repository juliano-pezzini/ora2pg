-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE integrar_lotes_contabeis ( nm_usuario_p usuario.nm_usuario%type, nr_lote_contabil_p lote_contabil.nr_lote_contabil%type ) AS $body$
DECLARE

reg_integracao_p		gerar_int_padrao.reg_integracao;

BEGIN

reg_integracao_p.ie_operacao :=	'I';
reg_integracao_p.ds_id_origin := ''; -- Verificar o que deve ser colocado

-- 407 = o Evento que criamos no domínio
reg_integracao_p := gerar_int_padrao.gravar_integracao('407', nr_lote_contabil_p, nm_usuario_p, reg_integracao_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE integrar_lotes_contabeis ( nm_usuario_p usuario.nm_usuario%type, nr_lote_contabil_p lote_contabil.nr_lote_contabil%type ) FROM PUBLIC;

