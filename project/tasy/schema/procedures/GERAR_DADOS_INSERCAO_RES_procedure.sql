-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE colunas AS ( nm_coluna_w varchar(255), nr_xml_w bigint);


CREATE OR REPLACE PROCEDURE gerar_dados_insercao_res ( cd_pessoa_fisica_p text, cd_profissional_p text, nm_usuario_p text) AS $body$
DECLARE




/* vetor */

type vetor is table of colunas index by integer;

/* globais */

vetor_w     vetor;
ivet      	integer;
ind     	integer;

dt_informacao_w		timestamp;
nr_seq_xml_w		bigint;
ds_informacao_w		varchar(4000);
ds_valor_w			varchar(4000);
DS_unidade_w		varchar(4000);

ds_comando_w    	varchar(32000);
ds_parametro_w    	varchar(32000);
ds_resultado_w		varchar(4000);
ie_tipo_w			varchar(3);

ds_macro_w			varchar(255);
ds_tipo_res_w		varchar(255);

C00 CURSOR FOR
	SELECT 	ie_tipo,
			ds_macro,
			obter_tipo_registro_res(ie_tipo)
	from   	res_paciente_resultado
	where  	cd_pessoa_fisica = cd_pessoa_fisica_p
	and    	nm_usuario = nm_usuario_p
	and		cd_profissional_dest = cd_profissional_p
	and		coalesce(ie_horizontal::text, '') = ''
	and    	ie_tipo in ('EL','SVA','AT')
	and		(ds_macro IS NOT NULL AND ds_macro::text <> '')
	group by ie_tipo, ds_macro
	order by ie_tipo;

C01 CURSOR FOR
	SELECT 	dt_informacao,
			nr_seq_xml
	from   	res_paciente_resultado
	where  	cd_pessoa_fisica = cd_pessoa_fisica_p
	and    	nm_usuario = nm_usuario_p
	and		cd_profissional_dest = cd_profissional_p
	and    	ie_tipo = ie_tipo_w
	and		ds_macro = ds_macro_w
	group by nr_seq_xml, dt_informacao
	order by dt_informacao desc;

C02 CURSOR FOR
	SELECT 	ds_informacao
	from   	res_paciente_resultado
	where  	cd_pessoa_fisica = cd_pessoa_fisica_p
	and    	nm_usuario = nm_usuario_p
	and		cd_profissional_dest = cd_profissional_p
	and    	ie_tipo = ie_tipo_w
	and		ds_macro = ds_macro_w
	and		coalesce(ie_horizontal::text, '') = ''
	group by ds_informacao
	order by ds_informacao;


C03 CURSOR FOR
	SELECT 	ds_informacao,
			ds_valor,
			ds_unidade
	from   	res_paciente_resultado
	where  	cd_pessoa_fisica = cd_pessoa_fisica_p
	and    	nm_usuario = nm_usuario_p
	and		cd_profissional_dest = cd_profissional_p
	and    	ie_tipo = ie_tipo_w
	and		ds_macro = ds_macro_w
	and    	trunc(dt_informacao) = to_date(vetor_w[ind].nm_coluna_w,'dd/mm/yy')
	and		nr_seq_xml = vetor_w[ind].nr_xml_w;



BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	delete
	from   	res_paciente_resultado
	where  	cd_pessoa_fisica = cd_pessoa_fisica_p
	and    	nm_usuario = nm_usuario_p
	and		cd_profissional_dest = cd_profissional_p
	and		ie_horizontal = 'S';

	commit;

	open C00;
	loop
	fetch C00 into
		ie_tipo_w,
		ds_macro_w,
		ds_tipo_res_w;
	EXIT WHEN NOT FOUND; /* apply on C00 */
		begin

		  ivet  := 0;

		  open  c01;
		  loop
		  fetch c01 into
			dt_informacao_w,
			nr_seq_xml_w;
		  EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			ivet := ivet + 1;
			vetor_w[ivet].nm_coluna_w 	:= dt_informacao_w;
			vetor_w[ivet].nr_xml_w 		:= nr_seq_xml_w;
			end;
		  end loop;
		  close c01;


		  /* completar vetor se necessário  */

		ind := ivet;
		while(ind < 20) loop
		  begin
		  ind := ind + 1;
		  vetor_w[ind].nm_coluna_w := null;
		  vetor_w[ind].nr_xml_w := null;
		  end;
		end loop;


	  INSERT INTO RES_PACIENTE_RESULTADO( 	NR_SEQUENCIA,
											DT_ATUALIZACAO,
											NM_USUARIO,
											DT_ATUALIZACAO_NREC,
											NM_USUARIO_NREC,
											CD_PESSOA_FISICA,
											IE_TIPO_CONSULTA,
											IE_TIPO,
											IE_EMPRESA,
											DT_INFORMACAO,
											DS_INFORMACAO,
											DS_MACRO,
											DS_RESULT1,
											DS_RESULT2,
											DS_RESULT3,
											DS_RESULT4,
											DS_RESULT5,
											DS_RESULT6,
											DS_RESULT7,
											DS_RESULT8,
											DS_RESULT9,
											DS_RESULT10,
											DS_RESULT11,
											DS_RESULT12,
											DS_RESULT13,
											DS_RESULT14,
											DS_RESULT15,
											DS_RESULT16,
											DS_RESULT17,
											DS_RESULT18,
											DS_RESULT19,
											DS_RESULT20,
											IE_DATA,
											IE_HORIZONTAL,
											cd_profissional_dest)
								VALUES ( 	nextval('res_paciente_resultado_seq'),
											clock_timestamp(),
											nm_usuario_p,
											clock_timestamp(),
											nm_usuario_p,
											cd_pessoa_fisica_p,
											'C',
											ie_tipo_w,
											'UNI',
											to_date(vetor_w[1].nm_coluna_w,'dd/mm/yy'),
											ds_tipo_res_w,
											ds_macro_w,
											vetor_w[1].nm_coluna_w,
											vetor_w[2].nm_coluna_w,
											vetor_w[3].nm_coluna_w,
											vetor_w[4].nm_coluna_w,
											vetor_w[5].nm_coluna_w,
											vetor_w[6].nm_coluna_w,
											vetor_w[7].nm_coluna_w,
											vetor_w[8].nm_coluna_w,
											vetor_w[9].nm_coluna_w,
											vetor_w[10].nm_coluna_w,
											vetor_w[11].nm_coluna_w,
											vetor_w[12].nm_coluna_w,
											vetor_w[13].nm_coluna_w,
											vetor_w[14].nm_coluna_w,
											vetor_w[15].nm_coluna_w,
											vetor_w[16].nm_coluna_w,
											vetor_w[17].nm_coluna_w,
											vetor_w[18].nm_coluna_w,
											vetor_w[19].nm_coluna_w,
											vetor_w[20].nm_coluna_w,
											'S',
											'S',
											cd_profissional_p);

		commit;

	   open C02;
	   loop
	   fetch C02 into
		ds_informacao_w;
	   EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		Select 	max(dt_informacao)
		into STRICT	dt_informacao_w
		from   	res_paciente_resultado
		where  	cd_pessoa_fisica = cd_pessoa_fisica_p
		and    	nm_usuario = nm_usuario_p
		and		cd_profissional_dest = cd_profissional_p
		and    	ie_tipo = ie_tipo_w
		and    	upper(ds_informacao) = upper(ds_informacao_w);


		INSERT INTO RES_PACIENTE_RESULTADO( 	NR_SEQUENCIA,
												DT_ATUALIZACAO,
												NM_USUARIO,
												DT_ATUALIZACAO_NREC,
												NM_USUARIO_NREC,
												CD_PESSOA_FISICA,
												IE_TIPO_CONSULTA,
												IE_TIPO,
												IE_EMPRESA,
												DT_INFORMACAO,
												DS_INFORMACAO,
												DS_MACRO,
												IE_HORIZONTAL,
												cd_profissional_dest)
								VALUES ( 	nextval('res_paciente_resultado_seq'),
											clock_timestamp(),
											nm_usuario_p,
											clock_timestamp(),
											nm_usuario_p,
											cd_pessoa_fisica_p,
											'C',
											ie_tipo_w,
											'UNI',
											dt_informacao_w,
											ds_informacao_w,
											ds_macro_w,
											'S',
											cd_profissional_p);


		end;
	   end loop;
	   close C02;


	   commit;

	   ind := 0;
	   while( ind < 20) loop
		  begin
		  ind := ind + 1;

		  open  c03;
		  loop
		  fetch c03 into
				ds_informacao_w,
				ds_valor_w,
				ds_unidade_w;
		  EXIT WHEN NOT FOUND; /* apply on c03 */
			begin

			ds_resultado_w	:= ds_valor_w ||' '|| ds_unidade_w;

			ds_comando_w  :=  ' update res_paciente_resultado '||
				  ' set ds_result' || to_char(ind) || ' = :ds_valor' ||
				  ' where ds_informacao = :ds_informacao '||
				  ' and cd_pessoa_fisica = :cd_pessoa_fisica '||
				  ' and cd_profissional_dest = :cd_profissional '||
				  ' and ie_horizontal = '|| chr(39) ||'S'|| chr(39) ||
				  ' and ie_tipo = :ie_tipo '||
				  ' and nm_usuario = :nm_usuario';

			ds_parametro_w  := 'ds_valor='||ds_resultado_w||'#@#@ds_informacao='||ds_informacao_w||'#@#@cd_pessoa_fisica='||cd_pessoa_fisica_p||'#@#@cd_profissional='||cd_profissional_p||'#@#@ie_tipo='||ie_tipo_w||'#@#@nm_usuario='||nm_usuario_p||'#@#@';


			CALL exec_sql_dinamico_bv('TASY', ds_comando_w, ds_parametro_w);

			commit;


			end;
		  end loop;
		  close c03;
		 end;
	  end loop;


		end;
	end loop;
	close C00;


end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dados_insercao_res ( cd_pessoa_fisica_p text, cd_profissional_p text, nm_usuario_p text) FROM PUBLIC;

