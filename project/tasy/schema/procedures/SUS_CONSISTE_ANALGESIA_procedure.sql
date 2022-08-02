-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_consiste_analgesia (NR_ATENDIMENTO_P bigint, NR_INTERNO_CONTA_P bigint, CD_PROC_REALIZADO_P bigint, DS_ERRO_P INOUT text) AS $body$
DECLARE


ds_erro_w			varchar(80) 	:= '';
qt_registros_w			bigint;
nr_sequencia_w			bigint;
qt_ato_6_w			bigint;
qt_proc_95003010_w		bigint;
qt_proc_95005013_w		bigint;
qt_proc_95006010_w		bigint;
qt_proc_99600072_w		bigint;


BEGIN

/* Em nenhum caso de parto e/ou cesariana, poderá ser utilizado tipo de ato 6-Anestesista, deve ser cobrado com código próprio */

Select	coalesce(max(nr_sequencia),0)
into STRICT 	nr_sequencia_w
from 	procedimento_paciente
where 	nr_atendimento 		= nr_atendimento_p
and	nr_interno_conta		= nr_interno_conta_p
and	cd_procedimento		= cd_proc_realizado_p
and	ie_origem_proced		= 2
and	coalesce(cd_motivo_exc_conta::text, '') = '';

select	count(*)
into STRICT	qt_ato_6_w
from	procedimento_participante
where	nr_sequencia		= nr_sequencia_w
and	ie_tipo_ato_sus		= 6;

select	sum(CASE WHEN cd_procedimento=95003010 THEN qt_procedimento  ELSE 0 END ),
	sum(CASE WHEN cd_procedimento=95005013 THEN qt_procedimento  ELSE 0 END ),
	sum(CASE WHEN cd_procedimento=95006010 THEN qt_procedimento  ELSE 0 END ),
	sum(CASE WHEN cd_procedimento=99600072 THEN qt_procedimento  ELSE 0 END )
into STRICT	qt_proc_95003010_w,
	qt_proc_95005013_w,
	qt_proc_95006010_w,
	qt_proc_99600072_w
from	procedimento_paciente
where 	nr_atendimento 		= nr_atendimento_p
and	nr_interno_conta		= nr_interno_conta_p
and	cd_procedimento		in (95003010,95005013,95006010,99600072)
and	ie_origem_proced		= 2
and	coalesce(cd_motivo_exc_conta::text, '') = '';

/* Analgesia I(95003010) usar para codigos 35001011,35007010,35006013,35086017,35025018,35080019 */

if (cd_proc_realizado_p in (35001011,35007010,35006013,35086017,35025018,35080019)) then
	begin
	if (qt_ato_6_w	> 0) then
		ds_erro_w := ds_erro_w||'2225'||'('||to_char(95003010)||') ';
	end if;
	if (qt_proc_95005013_w + qt_proc_95006010_w + qt_proc_99600072_w) > 0 then
		ds_erro_w := ds_erro_w||'2226'||'('||to_char(95003010)||') ';
	end if;
	if (qt_proc_95003010_w = 0 ) then
		ds_erro_w := ds_erro_w||'2227'||'('||to_char(95003010)||') ';
	end if;
	end;
end if;

/* Analgesia II(95005013) usar para codigos 35009012,35082011,35026014,35084014 */

if (cd_proc_realizado_p in (35009012,35082011,35026014,35084014)) then
	begin
	if (qt_ato_6_w	> 0) then
		ds_erro_w := ds_erro_w||'2225'||'('||to_char(95005013)||') ';
	end if;
	if (qt_proc_95003010_w + qt_proc_95006010_w + qt_proc_99600072_w) > 0 then
		ds_erro_w := ds_erro_w||'2226'||'('||to_char(95005013)||') ';
	end if;
	if (qt_proc_95005013_w = 0 ) then
		ds_erro_w := ds_erro_w||'2227'||'('||to_char(95005013)||') ';
	end if;
	end;
end if;

/* Analgesia III(95006010) usar para codigos 35027010,35085010,35028017 */

if (cd_proc_realizado_p in (35027010,35085010,35028017)) then
	begin
	if (qt_ato_6_w	> 0) then
		ds_erro_w := ds_erro_w||'2225'||'('||to_char(95006010)||') ';
	end if;
	if (qt_proc_95005013_w + qt_proc_95003010_w + qt_proc_99600072_w) > 0 then
		ds_erro_w := ds_erro_w||'2226'||'('||to_char(95006010)||') ';
	end if;
	if (qt_proc_95006010_w = 0 ) then
		ds_erro_w := ds_erro_w||'2227'||'('||to_char(95006010)||') ';
	end if;
	end;
end if;


/* Analgesia em queimados(99600072) usar para codigos iniciados em 38, para hospitais credenciados  */

ds_erro_p	:= ds_erro_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_consiste_analgesia (NR_ATENDIMENTO_P bigint, NR_INTERNO_CONTA_P bigint, CD_PROC_REALIZADO_P bigint, DS_ERRO_P INOUT text) FROM PUBLIC;

