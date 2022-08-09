-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_duplicar_grupo_material ( nr_seq_grupo_p pls_preco_grupo_material.nr_sequencia%type, ds_grupo_p pls_preco_grupo_material.ds_grupo%type, nm_usuario_p text, cd_estabelecimento text, nr_seq_grupo_out_p INOUT bigint) AS $body$
DECLARE



ie_cad_prestador_w		pls_preco_grupo_material.ie_cad_prestador%type;
ie_cobertura_contrato_w		pls_preco_grupo_material.ie_cobertura_contrato%type;
ie_gestao_cad_mat_w   		pls_preco_grupo_material.ie_gestao_cad_mat%type;
ie_situacao_w             	pls_preco_grupo_material.ie_situacao%type;
nr_seq_grupo_w			pls_preco_grupo_material.nr_sequencia%type;

/*Buscar os materiais do grupo que será duplicado*/

C01 CURSOR(nr_seq_grupo_p	pls_preco_grupo_material.nr_sequencia%type) FOR
	SELECT	a.nr_seq_material,
		a.nr_seq_estrutura_mat
	from	pls_preco_material a
	where	a.nr_seq_grupo = nr_seq_grupo_p;

BEGIN
if (length(ds_grupo_p) > 255)	then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(245308);

else
	/*Busca a seq do novo grupo*/

	select	nextval('pls_preco_grupo_material_seq')
	into STRICT	nr_seq_grupo_w
	;

	insert into pls_preco_grupo_material(	nr_sequencia,
			cd_estabelecimento,
			ie_situacao,
			ds_grupo,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_gestao_cad_mat,
			ie_cad_prestador,
			ie_cobertura_contrato)
		SELECT	nr_seq_grupo_w,
			cd_estabelecimento,
			ie_situacao,
			ds_grupo_p,
			clock_timestamp(),
			nm_usuario_p,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_gestao_cad_mat,
			ie_cad_prestador,
			ie_cobertura_contrato
		from	pls_preco_grupo_material
		where 	nr_sequencia = nr_seq_grupo_p;

	for r_c01 in C01(nr_seq_grupo_p) loop
		/*inserindo os itens no novo grupo*/

		insert into pls_preco_material(	nr_sequencia,dt_atualizacao,nm_usuario,
						nr_seq_grupo,nr_seq_material, nr_seq_estrutura_mat)
					values ( nextval('pls_preco_material_seq'), clock_timestamp(),nm_usuario_p,
						nr_seq_grupo_w, r_c01.nr_seq_material, r_c01.nr_seq_estrutura_mat);

	end loop;
end if;
nr_seq_grupo_out_p	:= nr_seq_grupo_w;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_duplicar_grupo_material ( nr_seq_grupo_p pls_preco_grupo_material.nr_sequencia%type, ds_grupo_p pls_preco_grupo_material.ds_grupo%type, nm_usuario_p text, cd_estabelecimento text, nr_seq_grupo_out_p INOUT bigint) FROM PUBLIC;
