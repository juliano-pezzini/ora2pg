-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_glosa_tiss ( cd_motivo_glosa_p text, ds_observacao_p text, ie_evento_p text, nr_sequencia_p bigint, ie_tipo_glosa_p text, nr_seq_prestador_p bigint, nr_seq_ocorrencia_p bigint, ds_parametro_um_p text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_conta_p bigint default null) AS $body$
DECLARE


				/* Foi adicionado o campo nr_seq_conta_p para sempre salvar o número da conta, quando gerar glosa para os itens
				cuidar quando adicionar um novo parâmetro na rotina, este ficou com o valor default, ou seja, pode não estar na
				chamada de todas as procedures que utilizam essa. OS 638040 */
/* IE_TIPO_GLOSA_P
	C - Conta
	CP - Conta procedimento
	CM - Conta material
	A - Autorização
	AP - Autorização procedimento
	AM - Autorização material
	R - Requisição
	RP - Requisição procedimento
	RM - Requisição material
*/
nr_sequencia_w			bigint;
nr_seq_procedimento_w		bigint;
nr_seq_material_w		bigint;
nr_seq_conta_w			pls_conta.nr_sequencia%type;


BEGIN

if (ie_tipo_glosa_p in ('C','A','R')) then
	nr_sequencia_w		:= nr_sequencia_p;
elsif (ie_tipo_glosa_p in ('CP','AP','RP')) then
	nr_seq_procedimento_w	:= nr_sequencia_p;
elsif (ie_tipo_glosa_p in ('CM','AM','RM')) then
	nr_seq_material_w	:= nr_sequencia_p;
end if;

/* Tratamento utilizado para sempre salvar a sequencia da conta quando gerar glosa para material ou procedimento */

if ( ie_tipo_glosa_p in ('CP','CM') ) then
	nr_sequencia_w := nr_seq_conta_p;
end if;


if (ie_tipo_glosa_p in ('C','CP','CM')) then
	CALL pls_gravar_conta_glosa(cd_motivo_glosa_p, nr_sequencia_w, nr_seq_procedimento_w,
		nr_seq_material_w, 'N', ds_observacao_p,
		nm_usuario_p, 'A', ie_evento_p,
		nr_seq_prestador_p, cd_estabelecimento_p, nr_seq_ocorrencia_p, null);
elsif (ie_tipo_glosa_p in ('A','AP','AM')) then
	CALL pls_gravar_motivo_glosa(cd_motivo_glosa_p, nr_sequencia_w, nr_seq_procedimento_w,
		nr_seq_material_w, ds_observacao_p, nm_usuario_p,
		'', ie_evento_p, nr_seq_prestador_p,
		null, nr_seq_ocorrencia_p);
elsif (ie_tipo_glosa_p in ('R','RP','RM')) then
	CALL pls_gravar_requisicao_glosa(cd_motivo_glosa_p, nr_sequencia_w, nr_seq_procedimento_w,
		nr_seq_material_w, ds_observacao_p, nm_usuario_p,
		nr_seq_prestador_p, cd_estabelecimento_p,
		nr_seq_ocorrencia_p, null);
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_glosa_tiss ( cd_motivo_glosa_p text, ds_observacao_p text, ie_evento_p text, nr_sequencia_p bigint, ie_tipo_glosa_p text, nr_seq_prestador_p bigint, nr_seq_ocorrencia_p bigint, ds_parametro_um_p text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_conta_p bigint default null) FROM PUBLIC;
