-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tof_gerar_meta_escalas ( nr_atendimento_p bigint, nr_sequencia_p bigint, nm_usuario_p text, nm_tabela_p text) AS $body$
DECLARE



nr_sequencia_w		bigint;
nr_seq_meta_w		bigint;
contador_w			integer;
ie_status_w			varchar(2);
nr_seq_meta_atend_w   bigint;
nr_seq_escala_w		bigint;
qt_reg_w		bigint;
qt_escala_w		bigint;


nr_seq_pend_regra_w	bigint;
vl_minimo_w		double precision;
vl_maximo_w		double precision;
nr_seq_sinal_vital_w	bigint;
nr_atendimento_w	bigint;
nm_atributo_w		varchar(50);
vl_atributo_w		double precision;
cd_pessoa_fisica_w	varchar(10);
qt_idade_w		bigint;
cd_setor_atendimento_w	bigint;
cd_escala_dor_w		varchar(10);
nr_seq_result_dor_w	bigint;
nm_tabela_w		varchar(80);
ie_escala_w		bigint;
nr_seq_result_w		bigint;
nr_seq_regra_result_w	bigint;
IE_INFORMACAO_w		varchar(10);
IE_TIPO_ATRIBUTO_w	varchar(50);
ie_informacao_ret_w	varchar(255);
ds_seq_meta_atend_w	varchar(255);


C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_meta,
		c.nr_seq_meta_atend,
		c.vl_minimo,
		c.vl_maximo,
		d.nm_tabela,
		d.NM_ATRIBUTO_INF,
		d.ie_escala,
		coalesce(c.nr_seq_result,0),
		c.IE_INFORMACAO,
		d.IE_TIPO_ATRIBUTO
	from	tof_meta_atend a,
		tof_meta m,
		tof_meta_item c,
		VICE_ESCALA d
	where	m.nr_sequencia = a.nr_seq_meta
	and	m.nr_sequencia	= c.nr_seq_meta
	and	d.nr_sequencia = c.NR_SEQ_ESCALA
	and	a.nr_atendimento = nr_atendimento_p
	and	m.ie_regra = 'ESC'
	and	upper(d.nm_tabela)	= nm_tabela_p
	and	coalesce(m.ie_situacao,'A') = 'A'
	and	coalesce(c.nr_seq_meta_atend::text, '') = ''
	and	coalesce(a.dt_finalizacao::text, '') = ''
	
union all

	SELECT	0,
		0,
		c.nr_seq_meta_atend,
		c.vl_minimo,
		c.vl_maximo,
		d.nm_tabela,
		d.NM_ATRIBUTO_INF,
		d.ie_escala,
		coalesce(c.nr_seq_result,0),
		c.IE_INFORMACAO,
		d.IE_TIPO_ATRIBUTO
	from	tof_meta m,
		tof_meta_item c,
		VICE_ESCALA d
	where	m.nr_sequencia	= c.nr_seq_meta
	and	d.nr_sequencia = c.NR_SEQ_ESCALA
	and	m.ie_regra = 'ESC'
	and	upper(d.nm_tabela)	= nm_tabela_p
	and	coalesce(m.ie_situacao,'A') = 'A'
	and	(c.nr_seq_meta_atend IS NOT NULL AND c.nr_seq_meta_atend::text <> '');


BEGIN

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	nr_seq_meta_w,
	nr_seq_meta_atend_w,
	vl_minimo_w,
	vl_maximo_w,
	nm_tabela_w,
	nm_atributo_w,
	ie_escala_w,
	nr_seq_regra_result_w,
	IE_INFORMACAO_w,
	IE_TIPO_ATRIBUTO_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin


	if	((nm_tabela_w = 'ESCALA_EIF') or ( IE_TIPO_ATRIBUTO_w	<> 'VARCHAR2')) and
		(( coalesce(vl_minimo_w::text, '') = '' ) or ( coalesce(vl_maximo_w::text, '') = '' )) then

		qt_reg_w := 0;

	elsif (IE_TIPO_ATRIBUTO_w	= 'VARCHAR2') and (coalesce(IE_INFORMACAO_w::text, '') = '') then

		qt_reg_w := 0;

	elsif (nm_tabela_w = 'ESCALA_EIF') then



		select	count(*)
		into STRICT	qt_reg_w
		from	escala_eif e
		where	e.nr_sequencia = nr_sequencia_p
		and	somente_numero(obter_resultado_escala_eif(e.nr_sequencia,'T')) >=  vl_minimo_w
		and	somente_numero(obter_resultado_escala_eif(e.nr_sequencia,'T')) <=  vl_maximo_w;

		if (qt_reg_w = 0) then

			select	count(*)
			into STRICT	qt_reg_w
			from	escala_eif e
			where	e.nr_sequencia = nr_sequencia_p
			and	somente_numero(obter_resultado_escala_eif(e.nr_sequencia,'S')) = nr_seq_regra_result_w;

		end if;



	elsif (IE_TIPO_ATRIBUTO_w	= 'VARCHAR2') then


		qt_reg_w := OBTER_VALOR_DINAMICO_PEP(	'select	count(*)'||
						' from  '||nm_tabela_w||' '||
						' where	nr_sequencia = :nr_sequencia'||
						' and	'||nm_atributo_w||' = '||IE_INFORMACAO_w, 'nr_sequencia='||nr_sequencia_p, qt_reg_w);


	else
		qt_reg_w := OBTER_VALOR_DINAMICO_PEP(	'select	count(*)'||
						' from  '||nm_tabela_w||' '||
						' where	nr_sequencia = :nr_sequencia'||
						' and	'||nm_atributo_w||' between '||vl_minimo_w||' and '||vl_maximo_w, 'nr_sequencia='||nr_sequencia_p, qt_reg_w);
	end if;





	if (qt_reg_w > 0 ) then

		ie_status_w := 'N';

	else

		ie_status_w := 'A';

	end if;


	if ( ie_status_w = 'N') and (nr_seq_meta_atend_w IS NOT NULL AND nr_seq_meta_atend_w::text <> '')then

		ds_seq_meta_atend_w := to_char(nr_seq_meta_atend_w)||',';

		CALL gerar_tof_meta_atend_paciente(nr_atendimento_p,ds_seq_meta_atend_w,nm_usuario_p);

	else

		if (nr_sequencia_w > 0) then

			Select  nextval('tof_meta_atend_hor_seq')
			into STRICT	nr_seq_meta_atend_w
			;

			insert into tof_meta_atend_hor(	nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_seq_meta_atend,
							ie_status,
							dt_geracao,
							ds_observacao,
							dt_liberacao)
						values (	nr_seq_meta_atend_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_sequencia_w,
							ie_status_w,
							clock_timestamp(),
							'',
							clock_timestamp());
			commit;

			CALL Alterar_status_tof_meta(nr_seq_meta_atend_w, nm_usuario_p);

		end if;

	end if;

	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tof_gerar_meta_escalas ( nr_atendimento_p bigint, nr_sequencia_p bigint, nm_usuario_p text, nm_tabela_p text) FROM PUBLIC;

