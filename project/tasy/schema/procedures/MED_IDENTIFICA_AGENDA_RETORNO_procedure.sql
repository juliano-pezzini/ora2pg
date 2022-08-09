-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_identifica_agenda_retorno (dt_agenda_p timestamp, cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_medico_p text, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE

 
qt_dia_conv_w		integer	:=0;
nr_seq_agenda_cons_w	bigint;
dt_agenda_w		timestamp;
qt_dia_retorno_w	bigint;
ie_classif_agenda_w	varchar(5);
ie_tipo_classif_w	varchar(1);

ds_retorno_w		varchar(240)	:= '';

/* obter agenda consulta período */
 
c02 CURSOR FOR 
SELECT	coalesce(b.nr_sequencia,0) 
from	agenda a, 
		agenda_consulta b 
where	a.cd_tipo_agenda	= 3 
and		a.cd_agenda			= b.cd_agenda	 
and		b.ie_status_agenda	= 'E' 
and		b.cd_pessoa_fisica	= cd_pessoa_fisica_p 
and		b.cd_convenio		= cd_convenio_p 
and		trunc(b.dt_agenda)			>= trunc(dt_agenda_p) - qt_dia_conv_w 
and		obter_tipo_classif_agecons(ie_classif_agenda) = 'C' 
order by 
	b.dt_agenda;


BEGIN 
if (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') then 
	/* obter período retorno agenda consulta */
 
	 
	/* obter período retorno convênio */
 
	begin 
	select	count(*) 
	into STRICT	qt_dia_conv_w 
	from	med_regra_convenio_retorno 
	where	cd_convenio	= cd_convenio_p 
	and		cd_medico	= cd_medico_p;
	exception 
		when others then 
			qt_dia_conv_w := 0;
	end;
	 
	if (qt_dia_conv_w > 0) then 
		select	max(coalesce(qt_dia,0)) 
		into STRICT	qt_dia_conv_w 
		from	med_regra_convenio_retorno 
		where	cd_convenio	= cd_convenio_p 
		and		cd_medico	= cd_medico_p;
	else 
		select	max(coalesce(qt_dia,0)) 
		into STRICT	qt_dia_conv_w 
		from	med_regra_convenio_retorno 
		where	cd_convenio	= cd_convenio_p 
		and		coalesce(cd_medico::text, '') = '';		
	end if;
	 
	if (coalesce(qt_dia_conv_w,0) > 0) then 
		/* obter agenda consulta retorno */
 
		open c02;
		loop 
		fetch c02 into	nr_seq_agenda_cons_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
			begin 
			nr_seq_agenda_cons_w	:= nr_seq_agenda_cons_w;
			end;
		end loop;
		close c02;
 
		if (coalesce(nr_seq_agenda_cons_w,0) > 0) then 
			select	dt_agenda, 
					ie_classif_agenda 
			into STRICT	dt_agenda_w, 
					ie_classif_agenda_w 
			from	agenda_consulta 
			where	nr_sequencia	= nr_seq_agenda_cons_w;
 
			/* obter período retorno agenda consulta */
 
			qt_dia_retorno_w	:= trunc(trunc(dt_agenda_p) - trunc(dt_agenda_w));
 
			/*if	(nvl(qt_dia_retorno_w,0) <= qt_dia_conv_w) then*/
 
			if (coalesce(qt_dia_retorno_w,0) <= qt_dia_conv_w) then 
				ds_retorno_w	:=	'O paciente esta sendo reagendado em período menor que o liberado pelo convênio.'||CHR(13)||CHR(10)|| 
									'Convênio: ' || substr(obter_nome_convenio(cd_convenio_p),1,40)	||CHR(13)||CHR(10)|| 
									'Lib convênio: ' || qt_dia_conv_w || ' dia(s)' 			||CHR(13)||CHR(10)|| 
									'Data agenda: ' || to_char(dt_agenda_w,'dd/mm/yyyy hh24:mi:ss');
			end if;
		end if;
	end if;
end if;
 
ds_retorno_p := ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_identifica_agenda_retorno (dt_agenda_p timestamp, cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_medico_p text, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;
