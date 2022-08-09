-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajusta_regra_glosa_opm () AS $body$
DECLARE


cd_procedimento_ww	bigint;
cd_procedimento_w	bigint;
ie_origem_proced_ww	bigint;
ie_origem_proced_w	bigint;
ie_situacao_w		varchar(5);
qt_liberada_w		double precision;
nr_seq_regra_opm_w	bigint;
nr_seq_regra_w		bigint;





C01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_procedimento,
		ie_origem_proced,
		ie_situacao,
		qt_liberada
	from	pls_procedimento_opm;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_regra_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	ie_situacao_w,
	qt_liberada_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if	((cd_procedimento_w <> cd_procedimento_ww)	or (ie_origem_proced_w <> ie_origem_proced_ww))	or (coalesce(cd_procedimento_ww::text, '') = '')	then

		select 	nextval('pls_regra_glosa_proc_opm_seq')
		into STRICT	nr_seq_regra_opm_w
		;

		cd_procedimento_ww	:= cd_procedimento_w;
		ie_origem_proced_ww	:= ie_origem_proced_w;

		insert into pls_regra_glosa_proc_opm( 	NR_SEQUENCIA, IE_SITUACAO , QT_LIBERADA ,
							CD_PROCEDIMENTO , IE_ORIGEM_PROCED , DT_INICIO_VIGENCIA,
							DT_ATUALIZACAO , NM_USUARIO)
		values (	nr_seq_regra_opm_w,ie_situacao_w, qt_liberada_w,
							cd_procedimento_w,ie_origem_proced_w,clock_timestamp(),
							clock_timestamp(),'PHILIPS');

		update	pls_procedimento_opm
		set	nr_seq_regra = nr_seq_regra_opm_w
		where	nr_sequencia = nr_seq_regra_w;

	elsif (nr_seq_regra_opm_w IS NOT NULL AND nr_seq_regra_opm_w::text <> '')	then
		insert into pls_regra_glosa_proc_opm(	NR_SEQUENCIA, IE_SITUACAO , QT_LIBERADA ,
							CD_PROCEDIMENTO , IE_ORIGEM_PROCED , DT_INICIO_VIGENCIA,
							DT_ATUALIZACAO , NM_USUARIO)
		values (	nr_seq_regra_opm_w,ie_situacao_w, qt_liberada_w,
							cd_procedimento_w,ie_origem_proced_w,clock_timestamp(),
							clock_timestamp(),'PHILIPS');
		update	pls_procedimento_opm
		set	nr_seq_regra = nr_seq_regra_opm_w
		where	nr_sequencia = nr_seq_regra_w;

	end if;

	end;
end loop;
close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajusta_regra_glosa_opm () FROM PUBLIC;
