-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_w_odontograma ( nr_seq_boca_sit_p bigint, cd_pessoa_fisica_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_sql_w			varchar(4000);
ds_values_w			varchar(4000);
cd_dente_w			bigint;
cd_situacao_inicial_w		varchar(20);
cd_regiao_boca_w		varchar(10);
cd_face_dente_w			varchar(20);
nr_seq_odonto_w			bigint;
ie_doenca_periodontal_w		varchar(10);
ie_alter_tecido_mole_w		varchar(10);
cd_pessoa_fisica_w		bigint;
ie_dente_duplic_w		bigint;
cd_face_atual_w			varchar(10);
ie_face_sup_w			varchar(1);
ie_face_inf_w			varchar(1);
ie_face_esq_w			varchar(1);
ie_face_centro_w		varchar(1);
ie_face_dir_w			varchar(1);

C01 CURSOR FOR
	/* Situação atual */

	SELECT	b.cd_dente,
		b.cd_situacao_atual
	from	pes_fis_boca_dente b,
		pes_fis_boca a
	where	a.nr_sequencia = b.nr_seq_pes_fis_boca
	and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
	and	clock_timestamp() between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia,clock_timestamp())
	and	coalesce(nr_seq_boca_sit_p::text, '') = ''
	/* Situação passada como parâmetro, naquela data */

	
union all

	SELECT 	c.cd_dente,
		b.cd_situacao
	from   	pes_fis_boca_dente c,
		pes_fis_boca_sit_dente b,
		pes_fis_boca_situacao a
	where	a.nr_sequencia	= b.nr_seq_pes_fis_boca_sit
	and	b.nr_seq_dente	= c.nr_sequencia
	and	a.nr_sequencia	= nr_seq_boca_sit_p
	and	(nr_seq_boca_sit_p IS NOT NULL AND nr_seq_boca_sit_p::text <> '')
	order by 1; -- Deixar sempre com order by para não da erro de insert na concatenação!!!
C02 CURSOR FOR
	/* Face dos dentes atual */

	SELECT 	a.cd_dente,
		a.cd_regiao_boca,
		CASE WHEN position('I'  cd_face_dente)=0 THEN CASE WHEN position('O' in cd_face_dente)=0 THEN 'N'  ELSE 'S' END   ELSE 'S' END  ie_face_sup,
		CASE WHEN position('L' in cd_face_dente)=0 THEN CASE WHEN position('P' in cd_face_dente)=0 THEN 'N'  ELSE 'S' END   ELSE 'S' END  ie_dente_inf,
		CASE WHEN position('D' in cd_face_dente)=0 THEN 'N'  ELSE 'S' END  ie_face_esq,
		CASE WHEN position('V' in cd_face_dente)=0 THEN 'N'  ELSE 'S' END  ie_face_centro,
		CASE WHEN position('M' in cd_face_dente)=0 THEN 'N'  ELSE 'S' END  ie_face_dir,
		b.ie_sinais_doenca_periodont,
		b.ie_alter_tecido_mole
	from 	pls_conta_proc_v a,
		pes_fis_boca_situacao b,
		pes_fis_boca c
	where 	c.nr_sequencia = b.nr_seq_pes_fis_boca
	and	a.cd_pessoa_fisica_conta = c.cd_pessoa_fisica
	and	a.ie_tipo_guia = '11'
	and	c.cd_pessoa_fisica = cd_pessoa_fisica_p
	and	a.dt_procedimento between c.dt_inicio_vigencia and c.dt_fim_vigencia
	and	coalesce(nr_seq_boca_sit_p::text, '') = ''
	
union

	/* Face dos dentes de determinada data */

	SELECT 	a.cd_dente,
		a.cd_regiao_boca,
		CASE WHEN position('I' in cd_face_dente)=0 THEN CASE WHEN position('O' in cd_face_dente)=0 THEN 'N'  ELSE 'S' END   ELSE 'S' END  ie_face_sup,
		CASE WHEN position('L' in cd_face_dente)=0 THEN CASE WHEN position('P' in cd_face_dente)=0 THEN 'N'  ELSE 'S' END   ELSE 'S' END  ie_dente_inf,
		CASE WHEN position('D' in cd_face_dente)=0 THEN 'N'  ELSE 'S' END  ie_face_esq,
		CASE WHEN position('V' in cd_face_dente)=0 THEN 'N'  ELSE 'S' END  ie_face_centro,
		CASE WHEN position('M' in cd_face_dente)=0 THEN 'N'  ELSE 'S' END  ie_face_dir,
		b.ie_sinais_doenca_periodont,
		b.ie_alter_tecido_mole
	from 	pls_conta_proc_v a,
		pes_fis_boca_situacao b,
		pes_fis_boca c
	where 	c.nr_sequencia = b.nr_seq_pes_fis_boca
	and	a.cd_pessoa_fisica_conta = c.cd_pessoa_fisica
	and	a.ie_tipo_guia = '11'
	and	c.cd_pessoa_fisica = cd_pessoa_fisica_p
	and	a.dt_procedimento between b.dt_inicio_vigencia and b.dt_fim_vigencia
	and	b.nr_sequencia = nr_seq_boca_sit_p
	and	(nr_seq_boca_sit_p IS NOT NULL AND nr_seq_boca_sit_p::text <> '')
	order by 1; -- Deixar sempre com order by para não da erro de insert na concatenação!!!
BEGIN

delete FROM w_pls_odontograma
where nm_usuario = nm_usuario_p;

select  nextval('w_pls_odontograma_seq')
into STRICT	nr_seq_odonto_w
;

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	insert into w_pls_odontograma values (nr_seq_odonto_w, clock_timestamp(), nm_usuario_p, cd_pessoa_fisica_p, 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H','H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H',  'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H',  'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H', 'H',  'H', 'H', 'H', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'H', 'H', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'H', 'H', 'H');

	commit;

	ds_sql_w	:=	'update w_pls_odontograma set IE_SINAIS_DOENCA_PERIODONT = :ie_sinais_doenca_periodont, IE_ALTER_TECIDO_MOLE = :ie_alter_tecido_mole';

	ie_dente_duplic_w := '0';

	open C01;
	loop
	fetch C01 into
		cd_dente_w,
		cd_situacao_inicial_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		--ds_sql_w := ds_sql_w || ', IE_DENTE_' || cd_dente_w || '';
		if (cd_dente_w <> ie_dente_duplic_w) then -- utilizado esta condição para não duplicar o dente no insert.
			if (cd_situacao_inicial_w = 'H') then
				begin
				ds_sql_w := ds_sql_w || ', IE_DENTE_' || cd_dente_w || '_SIT =';
				ds_sql_w := ds_sql_w || '''H''';
				end;
			end if;

			if (cd_situacao_inicial_w = 'E') then
				begin
				ds_sql_w := ds_sql_w || ', IE_DENTE_' || cd_dente_w || '_SIT =';
				ds_sql_w := ds_sql_w || '''E''';
				end;
			end if;

			if (cd_situacao_inicial_w = 'A') then
				begin
				ds_sql_w := ds_sql_w || ', IE_DENTE_' || cd_dente_w || '_SIT = ';
				ds_sql_w := ds_sql_w || '''A''';
				end;
			end if;

			if (cd_situacao_inicial_w = 'C') then
				begin
				ds_sql_w := ds_sql_w || ', IE_DENTE_' || cd_dente_w || '_SIT =';
				ds_sql_w := ds_sql_w || '''C''';
				end;
			end if;

			if (cd_situacao_inicial_w = 'R') then
				begin
				ds_sql_w := ds_sql_w || ', IE_DENTE_' || cd_dente_w || '_SIT =';
				ds_sql_w := ds_sql_w || '''R''';
				end;
			end if;
		ie_dente_duplic_w := cd_dente_w;
		end if;
		end;
	end loop;
	close C01;

	cd_face_atual_w := 'X';

	open C02;
	loop
	fetch C02 into
		cd_dente_w,
		cd_regiao_boca_w,
		ie_face_sup_w,
		ie_face_inf_w,
		ie_face_esq_w,
		ie_face_centro_w,
		ie_face_dir_w,
		ie_doenca_periodontal_w,
		ie_alter_tecido_mole_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (cd_face_atual_w <> cd_face_dente_w) then
			cd_face_atual_w := 'X';
		end if;

		if (ie_face_sup_w = 'S') and (ie_dente_duplic_w <> cd_dente_w) and -- utilizado esta condição para não duplicar o dente no insert.
		   (cd_face_atual_w <> 'O') then
			begin
			ds_sql_w := ds_sql_w || ', IE_DENTE_'|| cd_dente_w ||'_FACE_SUP = ';
			ds_sql_w := ds_sql_w || '''S''';
			cd_face_atual_w := 'O';
			end;
		end if;

		if (ie_face_esq_w = 'S')  and (ie_dente_duplic_w <> cd_dente_w) and (cd_face_atual_w <> 'D') then
			begin
			ds_sql_w := ds_sql_w || ', IE_DENTE_' || cd_dente_w || '_FACE_ESQ =';
			ds_sql_w := ds_sql_w || '''S''';
			cd_face_atual_w := 'D';
			end;
		end if;

		if (ie_face_centro_w = 'S')  and (ie_dente_duplic_w <> cd_dente_w) and (cd_face_atual_w <> 'V') then
			begin
			ds_sql_w := ds_sql_w || ', IE_DENTE_'|| cd_dente_w ||'_FACE_CEN = ';
			ds_sql_w := ds_sql_w || '''S''';
			cd_face_atual_w := 'V';
			end;
		end if;

		if (ie_face_dir_w = 'S')  and (ie_dente_duplic_w <> cd_dente_w) and (cd_face_atual_w <> 'M') then
			begin
			ds_sql_w := ds_sql_w || ', IE_DENTE_'|| cd_dente_w ||'_FACE_DIR =';
			ds_sql_w := ds_sql_w || '''S''';
			cd_face_atual_w := 'M';
			end;
		end if;

		if (ie_face_inf_w = 'S')  and (ie_dente_duplic_w <> cd_dente_w) and (cd_face_atual_w <> 'L') then
			begin
			ds_sql_w := ds_sql_w || ', IE_DENTE_'|| cd_dente_w ||'_FACE_INF = ';
			ds_sql_w := ds_sql_w || '''S''';
			cd_face_atual_w := 'L';
			end;
		end if;

		ie_dente_duplic_w := cd_dente_w;

	end;
	end loop;
	close C02;

	ds_sql_w := ds_sql_w || ' where nr_sequencia = ' || nr_seq_odonto_w;

	EXECUTE ds_sql_w using ie_doenca_periodontal_w, ie_alter_tecido_mole_w;
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_w_odontograma ( nr_seq_boca_sit_p bigint, cd_pessoa_fisica_p bigint, nm_usuario_p text) FROM PUBLIC;
