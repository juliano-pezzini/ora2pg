-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dime_reg_bp_passivo ( nr_seq_controle_p bigint, cd_estabelecimento_p text, nm_usuario_p text, dt_referencia_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar as informações referentes às saidas de valores de NF
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_linha_w			varchar(8000);
ds_quadro_w			varchar(2);
nr_linha_w			bigint	:= qt_linha_p;
nr_seq_registro_w		bigint 	:= nr_sequencia_p;
separador_w			varchar(1)	:= ds_separador_p;
tp_registro_w			varchar(2);
vl_inicial_estoque_w		double precision	:= 0;
vl_final_estoque_w		double precision	:= 0;
vl_resumo_w			double precision	:= 0;
vl_receita_w			double precision	:= 0;
nr_item_resumo_w		valor_dominio.vl_dominio%type;
dt_inicial_w			timestamp;
dt_final_w			timestamp;
nr_seq_demo_w			fis_dime_controle.nr_seq_demo_passivo%type;

c_valores CURSOR FOR
	SELECT	nr_seq_apres,
		ds_rubrica,
		vl_1_coluna vl_coluna
	from	ctb_demo_rubrica_v
	where	nr_seq_demo	= nr_seq_demo_w
	order by
		nr_seq_apres;

c_valores_w	c_valores%rowtype;


BEGIN
if (to_char(dt_referencia_p, 'mm') = '06') then
	ds_quadro_w	:= '82';
	tp_registro_w	:= '82';

	select	max(a.nr_seq_demo_passivo)
	into STRICT	nr_seq_demo_w
	from	fis_dime_controle	a
	where	a.nr_sequencia	= nr_seq_controle_p;

	open c_valores;
	loop
	fetch c_valores into
		c_valores_w;
	EXIT WHEN NOT FOUND; /* apply on c_valores */
		begin
		ds_linha_w	:= 	tp_registro_w								|| separador_w ||
					ds_quadro_w								|| separador_w ||
					substr(coalesce(c_valores_w.nr_seq_apres,0),1,4)				|| separador_w ||
					lpad(replace(campo_mascara(c_valores_w.vl_coluna,2),'.',''),17,'0')	|| separador_w;

		ds_arquivo_w		:= substr(ds_linha_w,1,4000);
		ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
		nr_seq_registro_w	:= nr_seq_registro_w + 1;
		nr_linha_w		:= nr_linha_w + 1;

		insert into w_dime_arquivo(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_controle_dime,
			nr_linha,
			cd_registro,
			ds_arquivo)
		values (nextval('w_dime_arquivo_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_controle_p,
			nr_linha_w,
			tp_registro_w,
			ds_arquivo_w);
		end;
	end loop;
	close c_valores;
end if;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dime_reg_bp_passivo ( nr_seq_controle_p bigint, cd_estabelecimento_p text, nm_usuario_p text, dt_referencia_p timestamp, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

