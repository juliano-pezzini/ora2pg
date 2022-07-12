-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_demonstrativo_analise_pck.obter_existe_conta_paga_prot ( ie_prest_demonstrativo_gl_p pls_web_param_geral.ie_prest_demonstrativo%type, nr_seq_prestador_rel_gl_p pls_prestador.nr_sequencia%type, nr_seq_usuario_web_p pls_regra_demons_analise.nr_seq_usuario%type, nr_seq_protocolo_p bigint) RETURNS varchar AS $body$
DECLARE


ie_status_w					pls_protocolo_conta.ie_status%type;
qt_registros_prot_ref_w				integer;

current_setting('pls_demonstrativo_analise_pck.c01')::CURSOR( CURSOR FOR
	SELECT	nr_sequencia nr_seq_conta
	from	pls_conta
	where	nr_seq_protocolo	= nr_seq_protocolo_p
	and	ie_status		= 'F'
	
union all

	SELECT	b.nr_sequencia nr_seq_conta
	from	pls_conta		b,
		pls_protocolo_conta	a
	where	nr_seq_prot_referencia	= nr_seq_protocolo_p
	and	b.nr_seq_protocolo	= a.nr_sequencia
	and	b.ie_status		= 'F';
						
BEGIN

CALL pls_demonstrativo_analise_pck.atualizar_regras_demonstrativo(ie_prest_demonstrativo_gl_p,nr_seq_prestador_rel_gl_p,nr_seq_usuario_web_p);

if (current_setting('pls_demonstrativo_analise_pck.dados_regra_demonstrativo_w')::dados_regra_demons_analise.ie_somente_guia_paga = 'N') then
	return 'S';	
else
	
	select	max(ie_status)
	into STRICT	ie_status_w
	from	pls_protocolo_conta
	where	nr_sequencia	= nr_seq_protocolo_p;
	
	select	count(1)
	into STRICT	qt_registros_prot_ref_w
	from	pls_protocolo_conta
	where	nr_seq_prot_referencia	= nr_seq_protocolo_p
	and	ie_status		= '6';
	
	if	((ie_status_w = '6') or (qt_registros_prot_ref_w > 0)) then
		return 'S';
	else
	
		for r_c01_w in current_setting('pls_demonstrativo_analise_pck.c01')::CURSOR( loop		
			if (pls_demonstrativo_analise_pck.obter_se_conta_paga(ie_prest_demonstrativo_gl_p,nr_seq_prestador_rel_gl_p,r_c01_w.nr_seq_conta) = 'S') then
				return 'S';
			end if;		
		end loop;
	end if;
end if;

return 'N';

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_demonstrativo_analise_pck.obter_existe_conta_paga_prot ( ie_prest_demonstrativo_gl_p pls_web_param_geral.ie_prest_demonstrativo%type, nr_seq_prestador_rel_gl_p pls_prestador.nr_sequencia%type, nr_seq_usuario_web_p pls_regra_demons_analise.nr_seq_usuario%type, nr_seq_protocolo_p bigint) FROM PUBLIC;