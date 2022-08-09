-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_rota_aprov_spa ( nr_seq_rota_p bigint, nm_usuario_p text ) AS $body$
DECLARE


/*
chamado do fonte java swing - gestão de spa
*/
nr_seq_rota_new 		spa_rota_aprovacao.nr_sequencia%type;
nr_sequencia_estrut_new		spa_rota_aprov_estrut.nr_sequencia%type;
nr_sequencia_resp_new		spa_rota_aprov_resp.nr_sequencia%type;
qt_rota_w 			bigint;

c_estruturas CURSOR FOR
	SELECT *
	from   spa_rota_aprov_estrut
	where  nr_seq_rota = nr_seq_rota_p;
c_estrut_w		c_estruturas%rowtype;

c_responsaveis CURSOR FOR
	SELECT 	*
	from	spa_rota_aprov_resp
	where 	nr_seq_estrutura = c_estrut_w.nr_sequencia;

c_resp_regra CURSOR FOR
	SELECT  *
	from  	spa_rota_aprov_resp_regra
	where 	nr_seq_rota = nr_seq_rota_p;

c_responsaveis_w 	c_responsaveis%rowtype;
c_resp_regra_w 		c_resp_regra%rowtype;


BEGIN
select 	count(1)
into STRICT 	qt_rota_w
from  	spa_rota_aprovacao
where 	nr_sequencia = nr_seq_rota_p;

if (qt_rota_w > 0)  then
	select 	nextval('spa_rota_aprovacao_seq')
	into STRICT 	nr_seq_rota_new
	;

	insert into spa_rota_aprovacao(
		cd_estabelecimento,
		ds_rota_aprovacao,
		dt_atualizacao,
		dt_atualizacao_nrec,
		ie_situacao,
		nm_usuario,
		nm_usuario_nrec,
		nr_sequencia)
		SELECT  cd_estabelecimento,
			ds_rota_aprovacao,
			clock_timestamp(),
			clock_timestamp(),
			ie_situacao,
			nm_usuario_p,
			nm_usuario_p,
			nr_seq_rota_new
		from    spa_rota_aprovacao
		where 	nr_sequencia = nr_seq_rota_p;


	open c_resp_regra;
	loop
	fetch c_resp_regra into
		c_resp_regra_w;
	EXIT WHEN NOT FOUND; /* apply on c_resp_regra */
		begin
		insert into spa_rota_aprov_resp_regra(
			cd_cargo,
			dt_atualizacao,
			dt_atualizacao_nrec,
			ie_juros,
			nm_usuario,
			nm_usuario_nrec,
			nr_mes_final,
			nr_mes_inicial,
			nr_nivel,
			nr_parcelas_final,
			nr_parcelas_inicial,
			nr_seq_rota,
			nr_sequencia,
			pr_desconto_final,
			pr_desconto_inicial,
			vl_desconto_final,
			vl_desconto_inicial,
			vl_negoc_maximo,
			vl_negoc_minimo)
		values ( c_resp_regra_w.cd_cargo,
			clock_timestamp(),
			clock_timestamp(),
			c_resp_regra_w.ie_juros,
			nm_usuario_p,
			nm_usuario_p,
			c_resp_regra_w.nr_mes_final,
			c_resp_regra_w.nr_mes_inicial,
			c_resp_regra_w.nr_nivel,
			c_resp_regra_w.nr_parcelas_final,
			c_resp_regra_w.nr_parcelas_inicial,
			nr_seq_rota_new,
			nextval('spa_rota_aprov_resp_regra_seq'),
			c_resp_regra_w.pr_desconto_final,
			c_resp_regra_w.pr_desconto_inicial,
			c_resp_regra_w.vl_desconto_final,
			c_resp_regra_w.vl_desconto_inicial,
			c_resp_regra_w.vl_negoc_maximo,
			c_resp_regra_w.vl_negoc_minimo);

		end;
	end loop;
	close c_resp_regra;

	open c_estruturas;
	loop
	fetch c_estruturas into
		c_estrut_w;
	EXIT WHEN NOT FOUND; /* apply on c_estruturas */
		begin

		select	nextval('spa_rota_aprov_estrut_seq')
		into STRICT	nr_sequencia_estrut_new
		;

		--copiando estruturas
		insert into spa_rota_aprov_estrut(
			cd_centro_custo,
			dt_atualizacao,
			dt_atualizacao_nrec,
			ie_situacao,
			ie_tipo_convenio,
			nm_usuario,
			nm_usuario_nrec,
			nr_seq_motivo,
			nr_seq_rota,
			nr_seq_tipo,
			nr_sequencia)
		values (
			c_estrut_w.cd_centro_custo,
			clock_timestamp(),
			clock_timestamp(),
			c_estrut_w.ie_situacao,
			c_estrut_w.ie_tipo_convenio,
			nm_usuario_p,
			nm_usuario_p,
			c_estrut_w.nr_seq_motivo,
			nr_seq_rota_new,
			c_estrut_w.nr_seq_tipo,
			nr_sequencia_estrut_new );

		open c_responsaveis;
		loop
		fetch c_responsaveis into
			c_responsaveis_w;
		EXIT WHEN NOT FOUND; /* apply on c_responsaveis */
			begin

			select 	nextval('spa_rota_aprov_resp_seq')
			into STRICT	nr_sequencia_resp_new
			;

			insert into
			spa_rota_aprov_resp(
				cd_cargo,
				dt_atualizacao,
				dt_atualizacao_nrec,
				ie_tipo_responsavel,
				nm_usuario,
				nm_usuario_aprovacao,
				nm_usuario_nrec,
				nr_ordem,
				nr_seq_estrutura,
				nr_sequencia)
				values (
				c_responsaveis_w.cd_cargo,
				clock_timestamp(),
				clock_timestamp(),
				c_responsaveis_w.ie_tipo_responsavel,
				nm_usuario_p,
				c_responsaveis_w.nm_usuario_aprovacao,
				nm_usuario_p,
				c_responsaveis_w.nr_ordem,
				nr_sequencia_estrut_new,
				nr_sequencia_resp_new);
			end;
		end loop;
		close c_responsaveis;
		end;
	end loop;
	close c_estruturas;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_rota_aprov_spa ( nr_seq_rota_p bigint, nm_usuario_p text ) FROM PUBLIC;
