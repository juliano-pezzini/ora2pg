-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rela_vagas_dialise_prc (nr_seq_unidade_p bigint, nr_seq_turno_p bigint) AS $body$
DECLARE

nr_linha_w		bigint;
nr_seq_turno_w		bigint;
nm_pessoa_fisica1_w	varchar(255);
nm_pessoa_fisica2_w	varchar(255);
nm_pessoa_fisica3_w	varchar(255);
nm_pessoa_fisica4_w	varchar(255);
nm_pessoa_fisica5_w	varchar(255);
nm_pessoa_fisica6_w	varchar(255);
ds_sigla1_w		varchar(10);
ds_sigla2_w		varchar(10);
ds_sigla3_w		varchar(10);
ds_sigla4_w		varchar(10);
ds_sigla5_w		varchar(10);
ds_sigla6_w		varchar(10);
ds_turno_w		varchar(80);
ds_unidade_w		varchar(80);
					
C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		ds_turno ds_turno, 
		(SELECT max(ds_unidade) 
			from	hd_unidade_dialise 
			where  nr_sequencia = nr_seq_unidade_p) ds_unidade 
	from	hd_turno a 
	where	nr_sequencia = nr_seq_turno_p 
	and	(nr_seq_turno_p IS NOT NULL AND nr_seq_turno_p::text <> '')	 
	
union
 
	select	nr_sequencia, 
		ds_turno ds_turno, 
		(select max(ds_unidade) 
			from	hd_unidade_dialise 
			where  nr_sequencia = nr_seq_unidade_p) ds_unidade_dialise 
	from	hd_turno a 
	where	coalesce(nr_seq_turno_p::text, '') = '' 
	and	a.ie_situacao = 'A' 
	order by ds_turno;						
 
					 
C02 CURSOR FOR 
	SELECT	row_number() OVER () AS linha 
	from	tabela_sistema LIMIT ((SELECT	max(qt_vagas) 
	from	HD_REGRA_TURNO_VAGA 
	where	nr_seq_turno 	 = nr_seq_turno_w 
	and	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento 
	and	nr_seq_unidade = nr_seq_unidade_p));
	
	 
 
	 

BEGIN 
 
delete 
from	W_RELATORIO_VAGAS_DIALISE;
 
 
open C01;
loop 
fetch C01 into	 
	nr_seq_turno_w, 
	ds_turno_w, 
	ds_unidade_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	insert into W_RELATORIO_VAGAS_DIALISE(nr_seq_turno, 
	ds_turno, 
	ie_tipo_banda, 
	ds_unidade) 
	values (nr_seq_turno_w, 
	ds_turno_w, 
	'C', 
	ds_unidade_w);
	end;
end loop;
close C01;
 
 
 
 
open C01;
loop 
fetch C01 into	 
	nr_seq_turno_w, 
	ds_turno_w, 
	ds_unidade_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
		 
	open C02;
	loop 
	fetch C02 into	 
		nr_linha_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		 
		 
		select	max(nm_pessoa_fisica), 
			max(ds_sigla) 
		into STRICT	nm_pessoa_fisica1_w, 
			ds_sigla1_w	 
		from	(	 
			SELECT	nm_pessoa_Fisica,	 
				ds_sigla, 
				row_number() OVER () AS linha 
			from	(	 
				SELECT distinct	substr(obter_nome_pf(a.cd_pessoa_fisica),1,255) nm_pessoa_fisica, 
						(select	max(x.ds_sigla) 
						from	hd_classificacao_sorologia x, 
							hd_paciente_classif_sor y 
						where	x.nr_sequencia = y.nr_seq_classificacao 
						and	y.cd_pessoa_fisica = a.cd_pessoa_fisica 
						and	y.nr_sequencia = (select	max(h.nr_sequencia) 
									from	hd_paciente_classif_sor h 
									where	h.cd_pessoa_fisica = a.cd_pessoa_fisica)) ds_sigla				 
						from	hd_escala_dialise a, 
							hd_escala_dialise_dia b, 
							hd_pac_renal_cronico c 
						where	b.nr_seq_escala = a.nr_sequencia 
						and	a.cd_pessoa_fisica = c.cd_pessoa_Fisica 
						and	coalesce(hd_obter_unidade_prc(c.cd_pessoa_fisica,'C'),c.nr_seq_unid_dialise) = nr_seq_unidade_p 
						and	coalesce(dt_fim_escala_dia::text, '') = '' 
						and	coalesce(a.dt_fim::text, '') = '' 
						and	b.ie_dia_semana = 2 
						and	b.nr_seq_turno = nr_seq_turno_w	 
						order by 1) alias12) alias13 
		where	linha = nr_linha_w;
		 
		select	max(nm_pessoa_fisica), 
			max(ds_sigla) 
		into STRICT	nm_pessoa_fisica2_w, 
			ds_sigla2_w	 
		from	(	 
			SELECT	nm_pessoa_Fisica,	 
				ds_sigla, 
				row_number() OVER () AS linha 
			from	(	 
				SELECT distinct	substr(obter_nome_pf(a.cd_pessoa_fisica),1,255) nm_pessoa_fisica, 
						(select	max(x.ds_sigla) 
						from	hd_classificacao_sorologia x, 
							hd_paciente_classif_sor y 
						where	x.nr_sequencia = y.nr_seq_classificacao 
						and	y.cd_pessoa_fisica = a.cd_pessoa_fisica 
						and	y.nr_sequencia = (select	max(h.nr_sequencia) 
									from	hd_paciente_classif_sor h 
									where	h.cd_pessoa_fisica = a.cd_pessoa_fisica)) ds_sigla				 
						from	hd_escala_dialise a, 
							hd_escala_dialise_dia b, 
							hd_pac_renal_cronico c 
						where	b.nr_seq_escala = a.nr_sequencia 
						and	a.cd_pessoa_fisica = c.cd_pessoa_Fisica 
						and	coalesce(hd_obter_unidade_prc(c.cd_pessoa_fisica,'C'),c.nr_seq_unid_dialise) = nr_seq_unidade_p 
						and	coalesce(dt_fim_escala_dia::text, '') = '' 
						and	coalesce(a.dt_fim::text, '') = '' 
						and	b.ie_dia_semana = 3 
						and	b.nr_seq_turno = nr_seq_turno_w	 
						order by 1) alias12) alias13 
		where	linha = nr_linha_w;
		 
		select	max(nm_pessoa_fisica), 
			max(ds_sigla) 
		into STRICT	nm_pessoa_fisica3_w, 
			ds_sigla3_w	 
		from	(	 
			SELECT	nm_pessoa_Fisica,	 
				ds_sigla, 
				row_number() OVER () AS linha 
			from	(	 
				SELECT distinct	substr(obter_nome_pf(a.cd_pessoa_fisica),1,255) nm_pessoa_fisica, 
						(select	max(x.ds_sigla) 
						from	hd_classificacao_sorologia x, 
							hd_paciente_classif_sor y 
						where	x.nr_sequencia = y.nr_seq_classificacao 
						and	y.cd_pessoa_fisica = a.cd_pessoa_fisica 
						and	y.nr_sequencia = (select	max(h.nr_sequencia) 
									from	hd_paciente_classif_sor h 
									where	h.cd_pessoa_fisica = a.cd_pessoa_fisica)) ds_sigla				 
						from	hd_escala_dialise a, 
							hd_escala_dialise_dia b, 
							hd_pac_renal_cronico c 
						where	b.nr_seq_escala = a.nr_sequencia 
						and	a.cd_pessoa_fisica = c.cd_pessoa_Fisica 
						and	coalesce(hd_obter_unidade_prc(c.cd_pessoa_fisica,'C'),c.nr_seq_unid_dialise) = nr_seq_unidade_p 
						and	coalesce(dt_fim_escala_dia::text, '') = '' 
						and	coalesce(a.dt_fim::text, '') = '' 
						and	b.ie_dia_semana = 4 
						and	b.nr_seq_turno = nr_seq_turno_w	 
						order by 1) alias12) alias13 
		where	linha = nr_linha_w;
		 
		select	max(nm_pessoa_fisica), 
			max(ds_sigla) 
		into STRICT	nm_pessoa_fisica4_w, 
			ds_sigla4_w	 
		from	(	 
			SELECT	nm_pessoa_Fisica,	 
				ds_sigla, 
				row_number() OVER () AS linha 
			from	(	 
				SELECT distinct	substr(obter_nome_pf(a.cd_pessoa_fisica),1,255) nm_pessoa_fisica, 
						(select	max(x.ds_sigla) 
						from	hd_classificacao_sorologia x, 
							hd_paciente_classif_sor y 
						where	x.nr_sequencia = y.nr_seq_classificacao 
						and	y.cd_pessoa_fisica = a.cd_pessoa_fisica 
						and	y.nr_sequencia = (select	max(h.nr_sequencia) 
									from	hd_paciente_classif_sor h 
									where	h.cd_pessoa_fisica = a.cd_pessoa_fisica)) ds_sigla				 
						from	hd_escala_dialise a, 
							hd_escala_dialise_dia b, 
							hd_pac_renal_cronico c 
						where	b.nr_seq_escala = a.nr_sequencia 
						and	a.cd_pessoa_fisica = c.cd_pessoa_Fisica 
						and	coalesce(hd_obter_unidade_prc(c.cd_pessoa_fisica,'C'),c.nr_seq_unid_dialise) = nr_seq_unidade_p 
						and	coalesce(dt_fim_escala_dia::text, '') = '' 
						and	coalesce(a.dt_fim::text, '') = '' 
						and	b.ie_dia_semana = 5 
						and	b.nr_seq_turno = nr_seq_turno_w	 
						order by 1) alias12) alias13 
		where	linha = nr_linha_w;
		 
		select	max(nm_pessoa_fisica), 
			max(ds_sigla) 
		into STRICT	nm_pessoa_fisica5_w, 
			ds_sigla5_w	 
		from	(	 
			SELECT	nm_pessoa_Fisica,	 
				ds_sigla, 
				row_number() OVER () AS linha 
			from	(	 
				SELECT distinct	substr(obter_nome_pf(a.cd_pessoa_fisica),1,255) nm_pessoa_fisica, 
						(select	max(x.ds_sigla) 
						from	hd_classificacao_sorologia x, 
							hd_paciente_classif_sor y 
						where	x.nr_sequencia = y.nr_seq_classificacao 
						and	y.cd_pessoa_fisica = a.cd_pessoa_fisica 
						and	y.nr_sequencia = (select	max(h.nr_sequencia) 
									from	hd_paciente_classif_sor h 
									where	h.cd_pessoa_fisica = a.cd_pessoa_fisica)) ds_sigla				 
						from	hd_escala_dialise a, 
							hd_escala_dialise_dia b, 
							hd_pac_renal_cronico c 
						where	b.nr_seq_escala = a.nr_sequencia 
						and	a.cd_pessoa_fisica = c.cd_pessoa_Fisica 
						and	coalesce(hd_obter_unidade_prc(c.cd_pessoa_fisica,'C'),c.nr_seq_unid_dialise) = nr_seq_unidade_p 
						and	coalesce(dt_fim_escala_dia::text, '') = '' 
						and	coalesce(a.dt_fim::text, '') = '' 
						and	b.ie_dia_semana = 6 
						and	b.nr_seq_turno = nr_seq_turno_w	 
						order by 1) alias12) alias13 
		where	linha = nr_linha_w;
		 
		 
		 
		select	max(nm_pessoa_fisica), 
			max(ds_sigla) 
		into STRICT	nm_pessoa_fisica6_w, 
			ds_sigla6_w	 
		from	(	 
			SELECT	nm_pessoa_Fisica,	 
				ds_sigla, 
				row_number() OVER () AS linha 
			from	(	 
				SELECT distinct	substr(obter_nome_pf(a.cd_pessoa_fisica),1,255) nm_pessoa_fisica, 
						(select	max(x.ds_sigla) 
						from	hd_classificacao_sorologia x, 
							hd_paciente_classif_sor y 
						where	x.nr_sequencia = y.nr_seq_classificacao 
						and	y.cd_pessoa_fisica = a.cd_pessoa_fisica 
						and	y.nr_sequencia = (select	max(h.nr_sequencia) 
									from	hd_paciente_classif_sor h 
									where	h.cd_pessoa_fisica = a.cd_pessoa_fisica)) ds_sigla				 
						from	hd_escala_dialise a, 
							hd_escala_dialise_dia b, 
							hd_pac_renal_cronico c 
						where	b.nr_seq_escala = a.nr_sequencia 
						and	a.cd_pessoa_fisica = c.cd_pessoa_Fisica 
						and	coalesce(hd_obter_unidade_prc(c.cd_pessoa_fisica,'C'),c.nr_seq_unid_dialise) = nr_seq_unidade_p 
						and	coalesce(dt_fim_escala_dia::text, '') = '' 
						and	coalesce(a.dt_fim::text, '') = '' 
						and	b.ie_dia_semana = 7 
						and	b.nr_seq_turno = nr_seq_turno_w	 
						order by 1) alias12) alias13 
		where	linha = nr_linha_w;
				 
		insert into W_RELATORIO_VAGAS_DIALISE(nm_pessoa_fisica_1, 
			nm_pessoa_fisica_2, 
			nm_pessoa_fisica_3, 
			nm_pessoa_fisica_4, 
			nm_pessoa_fisica_5, 
			nm_pessoa_fisica_6, 
			ds_sigla_1, 
			ds_sigla_2,	 
			ds_sigla_3, 
			ds_sigla_4, 
			ds_sigla_5, 
			ds_sigla_6, 
			nr_seq_turno, 
			nr_vaga, 
			ie_tipo_banda) 
			values (nm_pessoa_fisica1_w, 
			nm_pessoa_fisica2_w, 
			nm_pessoa_fisica3_w, 
			nm_pessoa_fisica4_w, 
			nm_pessoa_fisica5_w, 
			nm_pessoa_fisica6_w, 
			ds_sigla1_w, 
			ds_sigla2_w, 
			ds_sigla3_w, 
			ds_sigla4_w, 
			ds_sigla5_w, 
			ds_sigla6_w, 
			nr_seq_turno_w, 
			nr_linha_w, 
			'D');
		 
	 
		 
		end;
	end loop;
	close C02;
 
	end;
end loop;
close C01;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rela_vagas_dialise_prc (nr_seq_unidade_p bigint, nr_seq_turno_p bigint) FROM PUBLIC;
