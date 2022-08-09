-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_gerar_rotina_exame_ext (nr_seq_resultado_p bigint, lista_informacao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_exame_w		bigint;
nr_seq_exame_analito_w	bigint;
nr_seq_exame_princ_w	bigint;
nm_exame_analito_w	varchar(255);
nr_seq_apresent_w		bigint;
nr_seq_apresent_ww	bigint;
nm_exame_princ_w		varchar(255);
nr_sequencia_w		bigint		:= 0;
ie_contador_w		bigint		:= 0;
tam_lista_w		bigint;
ie_pos_virgula_w	smallint;
lista_informacao_w	varchar(2000);
nr_seq_unid_medida_w 	bigint;
nr_seq_metodo_w		bigint;
nr_seq_material_w	bigint;
ie_gera_analitos_exame_w varchar(1) := 'N';WITH RECURSIVE cte AS (


C01 CURSOR FOR
	SELECT	distinct nr_seq_exame,nm_exame,nr_seq_apresent
	from	exame_laboratorio WHERE nr_seq_superior = nr_seq_exame_w
  UNION ALL


C01 CURSOR FOR
	SELECT	distinct nr_seq_exame,nm_exame,nr_seq_apresent
	from	exame_laboratorio JOIN cte c ON (c.prior nr_seq_exame = nr_seq_superior)

) SELECT * FROM cte WHERE coalesce(ie_situacao,'A') = 'A'
	and	nr_seq_superior = nr_seq_exame_princ_w ORDER BY  3;
;

C02 CURSOR FOR
	SELECT	distinct nr_seq_exame, nm_exame, nr_seq_apresent
	from	exame_laboratorio
	where	coalesce(ie_situacao,'A') = 'A'
	and	nr_seq_superior = nr_seq_exame_w
	order by 3;


BEGIN

lista_informacao_w	:= lista_informacao_p;

ie_gera_analitos_exame_w := obter_param_usuario(7012, 7, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_gera_analitos_exame_w);

select 	coalesce(max(nr_sequencia),0)
into STRICT 	nr_sequencia_w
from 	exame_lab_result_item
where	nr_seq_resultado = nr_seq_resultado_p;

while	(lista_informacao_w IS NOT NULL AND lista_informacao_w::text <> '') or
	ie_contador_w > 200 loop
	begin
		tam_lista_w		:= length(lista_informacao_w);
		ie_pos_virgula_w	:= position(',' in lista_informacao_w);

		if (ie_pos_virgula_w <> 0) then
			nr_seq_exame_w		:= substr(lista_informacao_w,1,(ie_pos_virgula_w - 1));
			lista_informacao_w	:= substr(lista_informacao_w,(ie_pos_virgula_w + 1),tam_lista_w);
		end if;

		select 	coalesce(max(nr_sequencia),null)
		into STRICT	nr_seq_metodo_w
		from (	SELECT 	a.nr_sequencia
			from	metodo_exame_lab a,
				exame_lab_metodo b
			where 	a.nr_sequencia = b.nr_seq_metodo
			and 		b.nr_seq_exame = nr_seq_exame_w
			order by ie_prioridade) alias2 LIMIT 1;

		select	coalesce(max(nr_sequencia),null)
		into STRICT	nr_seq_material_w
		from (SELECT	a.nr_sequencia
				from		material_exame_lab a,
							exame_lab_material b
				where		a.nr_sequencia = b.nr_seq_material
				and		b.nr_seq_exame = nr_seq_exame_w
				order by ie_prioridade) alias2 LIMIT 1;

		select	coalesce(max(a.nr_sequencia),null)
		into STRICT	nr_seq_unid_medida_w
		from	lab_unidade_medida a,
			exame_laboratorio b
		where	a.nr_sequencia = b.nr_seq_unid_med
		and	b.nr_seq_exame = nr_seq_exame_w;

		nr_sequencia_w := nr_sequencia_w + 1;

		if (ie_gera_analitos_exame_w <> 'S') and (ie_gera_analitos_exame_w <> 'A') then
			insert into exame_lab_result_item(nr_seq_resultado,
					 nr_sequencia,
					 nr_seq_exame,
					 dt_atualizacao,
					 nm_usuario,
					 qt_resultado,
					 ds_resultado,
					 nr_seq_material,
					 pr_resultado,
					 ie_status,
					 dt_aprovacao,
					 nm_usuario_aprovacao,
					 ie_consiste,
					 nr_seq_metodo,
					 nr_seq_unid_med)
					values (nr_seq_resultado_p,
						nr_sequencia_w,
						nr_seq_exame_w,
						clock_timestamp(),
						nm_usuario_p,
						null,
						null,
						nr_seq_material_w,
						null,
						'',
						null,
						'',
						'S',
						nr_seq_metodo_w,
						nr_seq_unid_medida_w);
		else
				insert into exame_lab_result_item(nr_seq_resultado,
						 nr_sequencia,
						 nr_seq_exame,
						 dt_atualizacao,
						 nm_usuario,
						 qt_resultado,
						 ds_resultado,
						 nr_seq_material,
						 pr_resultado,
						 ie_status,
						 dt_aprovacao,
						 nm_usuario_aprovacao,
						 ie_consiste,
						 nr_seq_metodo,
						 nr_seq_unid_med)
						values (nr_seq_resultado_p,
							nr_sequencia_w,
							nr_seq_exame_w,
							clock_timestamp(),
							nm_usuario_p,
							null,
							null,
							nr_seq_material_w,
							null,
							'',
							null,
							'',
							'S',
							nr_seq_metodo_w,
							nr_seq_unid_medida_w);
			open C02;
			loop
			fetch C02 into
				nr_seq_exame_princ_w,
				nm_exame_princ_w,
				nr_seq_apresent_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				nr_sequencia_w := nr_sequencia_w + 1;
				insert into exame_lab_result_item(nr_seq_resultado,
								 nr_sequencia,
								 nr_seq_exame,
								 dt_atualizacao,
								 nm_usuario,
								 qt_resultado,
								 ds_resultado,
								 nr_seq_material,
								 pr_resultado,
								 ie_status,
								 dt_aprovacao,
								 nm_usuario_aprovacao,
								 ie_consiste,
								 nr_seq_metodo,
								 nr_seq_unid_med)
								values (nr_seq_resultado_p,
								nr_sequencia_w,
								nr_seq_exame_princ_w,
								clock_timestamp(),
								nm_usuario_p,
								null,
								null,
								null,
								null,
								'',
								null,
								'',
								'S',
								null,
								null);
				open C01;
				loop
				fetch C01 into
					nr_seq_exame_analito_w,
					nm_exame_analito_w,
					nr_seq_apresent_w;
				EXIT WHEN NOT FOUND; /* apply on C01 */
						begin
						nr_sequencia_w := nr_sequencia_w + 1;
						insert into exame_lab_result_item(nr_seq_resultado,
								 nr_sequencia,
								 nr_seq_exame,
								 dt_atualizacao,
								 nm_usuario,
								 qt_resultado,
								 ds_resultado,
								 nr_seq_material,
								 pr_resultado,
								 ie_status,
								 dt_aprovacao,
								 nm_usuario_aprovacao,
								 ie_consiste,
								 nr_seq_metodo,
								 nr_seq_unid_med)
								values (nr_seq_resultado_p,
								nr_sequencia_w,
								nr_seq_exame_analito_w,
								clock_timestamp(),
								nm_usuario_p,
								null,
								null,
								null,
								null,
								'',
								null,
								'',
								'S',
								null,
								null);
						end;
				end loop;
				close C01;
				end;
			end loop;
			close C02;

		end if;
		ie_contador_w	:= ie_contador_w + 1;
		end;
end loop;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_gerar_rotina_exame_ext (nr_seq_resultado_p bigint, lista_informacao_p text, nm_usuario_p text) FROM PUBLIC;
