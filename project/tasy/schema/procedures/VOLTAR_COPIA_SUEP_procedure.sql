-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE voltar_copia_suep ( nr_sequencia_suep_p bigint, nr_seq_suep_temp_p bigint) AS $body$
DECLARE


	ie_exist_copia_w varchar(1);

	nr_seq_item_c01_w	item_suep.nr_sequencia%type;
	ds_titulo_w			suep.ds_titulo%type;
	ds_suep_w			suep.ds_suep%type;

	nm_usuario_w		varchar(20);



	c01 CURSOR FOR
		SELECT	nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_tipo_item,
				nr_seq_suep,
				nr_seq_apres,
				ie_formato_busca,
				qt_dias_busca,
				qt_consultas,
				ie_restringir_tipo_atend,
				ie_tamanho_card
		from	w_suep_cad_item
		where	nr_seq_suep = nr_seq_suep_temp_p;

	c01_w			c01%rowtype;


BEGIN
if (nr_sequencia_suep_p IS NOT NULL AND nr_sequencia_suep_p::text <> '' AND nr_seq_suep_temp_p IS NOT NULL AND nr_seq_suep_temp_p::text <> '') then

	nm_usuario_w	:= wheb_usuario_pck.get_nm_usuario;

	select	coalesce(max('S'),'N')
	into STRICT	ie_exist_copia_w
	from	w_suep_cadastro
	where	nr_sequencia = nr_seq_suep_temp_p;


	if (ie_exist_copia_w = 'S') then

		select 	ds_titulo,
               	ds_suep
		into STRICT	ds_titulo_w,
		        ds_suep_w
		from	w_suep_cadastro
		where	nr_sequencia	= nr_seq_suep_temp_p
		and		nr_seq_suep_orig = nr_sequencia_suep_p;

		update	suep set
				ds_titulo = ds_titulo_w,
				ds_suep   = ds_suep_w
		where	nr_sequencia = nr_sequencia_suep_p;

		delete FROM item_suep where nr_seq_suep = nr_sequencia_suep_p;

		open c01;
			loop
			fetch c01 into c01_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
				begin

					select	nextval('item_suep_seq')
					into STRICT	nr_seq_item_c01_w
					;

					insert into item_suep(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						ie_tipo_item,
						nr_seq_suep,
						nr_seq_apres,
						ie_formato_busca,
						qt_dias_busca,
						qt_consultas,
						ie_restringir_tipo_atend,
						ie_tamanho_card
						) values (
						nr_seq_item_c01_w,
						clock_timestamp(),
						nm_usuario_w,
						clock_timestamp(),
						nm_usuario_w,
						c01_w.ie_tipo_item,
						nr_sequencia_suep_p,
						c01_w.nr_seq_apres,
						c01_w.ie_formato_busca,
						c01_w.qt_dias_busca,
						c01_w.qt_consultas,
						c01_w.ie_restringir_tipo_atend,
						c01_w.ie_tamanho_card
					);


					insert into INFORMACAO_SUEP(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						ie_tipo_diagnostico,
						ie_tipo_meta,
						ie_origem_glicemia,
						ie_result_exame,
						ie_classificacao_doenca,
						nr_seq_apres,
						nr_seq_inf,
						nr_seq_exame,
						nr_seq_item,
						cd_tipo_procedimento,
						ds_informacao_inst,
						ie_evolucao_clinica
						) SELECT
						nextval('informacao_suep_seq'),
						clock_timestamp(),
						nm_usuario_w,
						clock_timestamp(),
						nm_usuario_w,
						ie_tipo_diagnostico,
						ie_tipo_meta,
						ie_origem_glicemia,
						ie_result_exame,
						ie_classificacao_doenca,
						nr_seq_apres,
						nr_seq_inf,
						nr_seq_exame,
						nr_seq_item_c01_w,
						cd_tipo_procedimento,
						ds_informacao_inst,
						ie_evolucao_clinica
					from w_suep_cad_informacao
					where nr_seq_item = c01_w.nr_sequencia;


				end;
			end loop;
			close c01;


		commit;
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE voltar_copia_suep ( nr_sequencia_suep_p bigint, nr_seq_suep_temp_p bigint) FROM PUBLIC;
