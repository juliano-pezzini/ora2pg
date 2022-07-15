-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_item_req_motivo ( nm_usuario_p text, nr_requisicao_p bigint, nr_item_requisicao_p bigint, cd_motivo_baixa_p bigint, qt_baixar_p bigint) AS $body$
DECLARE


qt_requisitada_w  		double precision;
qt_baixar_w   		double precision;
qt_diferenca_w   		double precision;
qt_liberada_w   		bigint;
nr_seq_w   		bigint;
qt_estoque_w		double precision;
cd_material_w		bigint;
qt_conversao_mat_w	double precision;
qt_material_atendida_w	double precision;
dt_atendimento_w  	timestamp;
cd_motivo_baixa_w	sup_motivo_baixa_req.cd_motivo_baixa%type;



BEGIN
cd_motivo_baixa_w	:= obter_tipo_motivo_baixa_req(cd_motivo_baixa_p);

if (not cd_motivo_baixa_w in (1,4)) then
	begin
	select	count(*)
	into STRICT 	qt_liberada_w
	from 	requisicao_material
	where 	nr_requisicao = nr_requisicao_p
	and 	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

	if (qt_liberada_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(185845,'NR_REQUISICAO='||nr_requisicao_p);
		/*r.aise_application_error(-20011, 'A requisição ' || nr_requisicao_p || ' não está liberada para atendimento.' );*/

	end if;

	qt_baixar_w  	:= coalesce(qt_baixar_p,0);
	dt_atendimento_w 	:= clock_timestamp();

	select 	sum(coalesce(qt_material_requisitada,0)),
		max(cd_material)
	into STRICT 	qt_requisitada_w,
		cd_material_w
	from 	item_requisicao_material
	where 	nr_requisicao = nr_requisicao_p
	and 	nr_sequencia = nr_item_requisicao_p
	and 	obter_tipo_motivo_baixa_req(cd_motivo_baixa) = 0;

	qt_conversao_mat_w	:= obter_conversao_material(cd_material_w,'EC');
	qt_diferenca_w		:= qt_requisitada_w - qt_baixar_w;
	qt_estoque_w		:= qt_baixar_w / qt_conversao_mat_w;

	if (cd_motivo_baixa_w = 5) then
		qt_material_atendida_w	:=	qt_baixar_w;
	else
		qt_material_atendida_w	:=	0;
	end if;


	update 	item_requisicao_material
	set 	cd_motivo_baixa = cd_motivo_baixa_p,
		qt_material_atendida = qt_material_atendida_w,
		qt_material_requisitada = qt_baixar_w,
		qt_estoque = qt_estoque_w,
		dt_atendimento = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where 	nr_requisicao = nr_requisicao_p
	and 	nr_sequencia = nr_item_requisicao_p;

	if (qt_diferenca_w > 0) then
		begin
		select max(nr_sequencia) + 1
		into STRICT nr_seq_w
		from item_requisicao_material
		where nr_requisicao = nr_requisicao_p;

		qt_estoque_w	:= qt_diferenca_w / qt_conversao_mat_w;

		insert into item_requisicao_material(
			nr_requisicao,
			nr_sequencia,
			cd_estabelecimento,
			cd_material,
			qt_material_requisitada,
			qt_material_atendida,
			vl_material,
			dt_atualizacao,
			nm_usuario,
			cd_unidade_medida,
			cd_pessoa_recebe,
			cd_pessoa_atende,
			cd_motivo_baixa,
			qt_estoque,
			cd_unidade_medida_estoque,
			cd_conta_contabil,
			cd_material_req,
			ie_geracao)
		SELECT 	nr_requisicao,
			nr_seq_w,
			cd_estabelecimento,
			cd_material,
			qt_diferenca_w,
			0,
			vl_material,
			clock_timestamp(),
			nm_usuario_p,
			cd_unidade_medida,
			cd_pessoa_recebe,
			cd_pessoa_atende,
			0,
			qt_estoque_w,
			cd_unidade_medida_estoque,
			cd_conta_contabil,
			cd_material_req,
			'S'
		from 	item_requisicao_material
		where 	nr_requisicao = nr_requisicao_p
		and 	nr_sequencia  = nr_item_requisicao_p;
		end;
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_item_req_motivo ( nm_usuario_p text, nr_requisicao_p bigint, nr_item_requisicao_p bigint, cd_motivo_baixa_p bigint, qt_baixar_p bigint) FROM PUBLIC;

