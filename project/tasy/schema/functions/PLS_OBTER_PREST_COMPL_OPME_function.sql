-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_prest_compl_opme ( nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nr_seq_prestador_exec_p pls_requisicao.nr_seq_prestador_exec%type) RETURNS varchar AS $body$
DECLARE



/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Retornar se o prestador executante da requisição possui permissão para complementar
as solicitações de dados de OPME
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  x] Tasy (Delphi/Java) [ x  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w			varchar(1)	:= 'N';
qt_registro_w			integer;
qt_registro_anexo_w		integer;


BEGIN

--Verifica se o prestador executante possui regra para receber o complemento de OPME nas guias de internação
if (nr_seq_prestador_exec_p IS NOT NULL AND nr_seq_prestador_exec_p::text <> '' AND nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then

	select	sum(qt_registro)
	into STRICT	qt_registro_anexo_w
	from (SELECT 	count(1) qt_registro
		from	pls_requisicao_proc
		where	nr_seq_requisicao = nr_seq_requisicao_p
		and	ie_utiliza_opme = 'S'
		
union

		SELECT 	count(1) qt_registro
		from	pls_requisicao_mat
		where	nr_seq_requisicao = nr_seq_requisicao_p
		and (ie_utiliza_opme = 'S' or ie_tipo_anexo = 'OP')) alias5;

	if (pls_obter_se_controle_estab('RE') = 'S') then
		select	count(1)
		into STRICT	qt_registro_w
		from	pls_regra_compl_anexo_opme a,
			pls_regra_prest_anexo_opme b
		where	b.nr_seq_regra_compl_opme = a.nr_sequencia
		and	a.dt_inicio_vigencia <= clock_timestamp()
		and (coalesce(a.dt_fim_vigencia::text, '') = '' or a.dt_fim_vigencia > clock_timestamp())
		and	b.ie_situacao 		= 'A'
		and	b.nr_seq_prestador 	= nr_seq_prestador_exec_p
		and 	coalesce(a.cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento;
	else
		select	count(1)
		into STRICT	qt_registro_w
		from	pls_regra_compl_anexo_opme a,
			pls_regra_prest_anexo_opme b
		where	b.nr_seq_regra_compl_opme = a.nr_sequencia
		and	a.dt_inicio_vigencia <= clock_timestamp()
		and (coalesce(a.dt_fim_vigencia::text, '') = '' or a.dt_fim_vigencia > clock_timestamp())
		and	b.ie_situacao 		= 'A'
		and	b.nr_seq_prestador 	= nr_seq_prestador_exec_p;
	end if;

	if ( qt_registro_w > 0 and qt_registro_anexo_w > 0 ) then
		ds_retorno_w := 'S';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_prest_compl_opme ( nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nr_seq_prestador_exec_p pls_requisicao.nr_seq_prestador_exec%type) FROM PUBLIC;

