-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_verificar_parecer_benef ( nr_seq_proposta_p pls_proposta_adesao.nr_sequencia%type, nm_usuario_p text) AS $body$
DECLARE

		
nm_beneficiarios_w  varchar(4000) := '';
C01 CURSOR FOR
SELECT 	b.nr_sequencia,
        obter_nome_pf(b.cd_beneficiario) nm_beneficiario
from    pls_proposta_adesao a,
        pls_proposta_beneficiario b,
        pls_analise_adesao c,
        pls_entrevista_analise d,
        pls_analise_parecer e
where 	a.nr_sequencia = b.nr_seq_proposta
and   b.nr_sequencia = c.nr_seq_pessoa_proposta
and   c.nr_sequencia = d.nr_seq_analise
and 	e.nr_sequencia = d.nr_seq_parecer
and 	a.nr_sequencia = nr_seq_proposta_p
and 	e.ie_impedir_contratacao = 'S'
and 	coalesce(b.dt_cancelamento::text, '') = '';
BEGIN

for r_c01_w in C01 loop
begin
	nm_beneficiarios_w := nm_beneficiarios_w || r_c01_w.nm_beneficiario || ', ';
end;
end loop;
if (coalesce(length(nm_beneficiarios_w),0) > 0) then
	select  substr(nm_beneficiarios_w, 1, length(nm_beneficiarios_w)-2)
	into STRICT 	nm_beneficiarios_w
	;
	
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1168528, 'NM_BENEFICIARIO=' || nm_beneficiarios_w);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_verificar_parecer_benef ( nr_seq_proposta_p pls_proposta_adesao.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;

