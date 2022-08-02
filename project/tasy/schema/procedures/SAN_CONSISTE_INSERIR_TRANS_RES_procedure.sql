-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_consiste_inserir_trans_res (cd_pessoa_fisica_p text, ds_mensagem_p INOUT text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_mensagem_w			varchar(32767);
ds_mensagem_aux_w		varchar(32767);

nr_sangue_w			varchar(20);
ds_derivado_w			varchar(50);
ie_hemocomp_receb_estoque_w	varchar(1);

C01 CURSOR FOR
	SELECT	a.nr_sangue,
		a.ds_derivado
	from 	san_producao_consulta_v a
	where 	a.ie_classif_doacao in ('A','D')
	and	a.cd_doador = cd_pessoa_fisica_p
	and	coalesce(a.nr_seq_emp_saida::text, '') = ''
	and	coalesce(a.nr_seq_transfusao::text, '') = ''
	and	coalesce(a.nr_seq_inutil::text, '') = ''
	and	coalesce(a.ie_encaminhado,'N') = 'N'
	and	(	(ie_hemocomp_receb_estoque_w = 'N') or
			(	(ie_hemocomp_receb_estoque_w = 'S') and
				(	(a.dt_recebimento IS NOT NULL AND a.dt_recebimento::text <> '' AND dt_liberacao_bolsa IS NOT NULL AND dt_liberacao_bolsa::text <> '') or ((a.nr_seq_emp_ent IS NOT NULL AND a.nr_seq_emp_ent::text <> '') and (coalesce(a.dt_inicio_prod_emprestimo::text, '') = '' or (a.dt_fim_prod_emprestimo IS NOT NULL AND a.dt_fim_prod_emprestimo::text <> '')))
				)
			)
		)
	and	not exists (SELECT	1
				from	san_envio_derivado_val x,
					san_envio_derivado z
				where	z.nr_sequencia	= x.nr_seq_envio
				and	x.nr_seq_producao	= a.nr_sequencia
				and	x.dt_recebimento is  null)
	and	not exists (select	1
				from	san_controle_qualidade x,
					san_controle_qual_prod y
				where	x.nr_sequencia = y.nr_seq_qualidade
				and	y.nr_seq_producao = a.nr_sequencia
				and	coalesce(x.dt_liberacao::text, '') = '')
	and	a.ie_pai_reproduzido <> 'S';


BEGIN

ie_hemocomp_receb_estoque_w := obter_param_usuario(450, 230, Obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_hemocomp_receb_estoque_w);

open C01;
loop
fetch C01 into
	nr_sangue_w,
	ds_derivado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (length(ds_mensagem_aux_w || chr(13) || nr_sangue_w || ' - ' || ds_derivado_w) < 32767) then
		ds_mensagem_aux_w := ds_mensagem_aux_w || chr(13) || nr_sangue_w || ' - ' || ds_derivado_w;
	end if;

	end;
end loop;
close C01;

if (ds_mensagem_aux_w IS NOT NULL AND ds_mensagem_aux_w::text <> '') then
	ds_mensagem_w := wheb_mensagem_pck.get_texto(309903, 'DS_MENSAGEM_AUX_W=' || ds_mensagem_aux_w);
				/*
					Existem bolsas de doação autóloga ou direcionada para este paciente:
					#@DS_MENSAGEM_AUX_W#@
				*/
end if;

ds_mensagem_p := ds_mensagem_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_consiste_inserir_trans_res (cd_pessoa_fisica_p text, ds_mensagem_p INOUT text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

