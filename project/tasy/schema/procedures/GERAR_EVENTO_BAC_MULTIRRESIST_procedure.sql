-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evento_bac_multirresist ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

nr_seq_evento_w	bigint;
qt_reg_w	bigint;
qt_idade_w	bigint;
ie_tipo_atendimento_w	atendimento_paciente.ie_tipo_atendimento%type;

C01 CURSOR FOR 
	SELECT	nr_seq_evento 
	from	regra_envio_sms a, 
		ev_evento b 
	where	cd_estabelecimento	= cd_estabelecimento_p 
	and	ie_evento_disp = 'BMR' 
	and	qt_idade_w between coalesce(qt_idade_min,0)	and coalesce(qt_idade_max,9999) 
	and	a.nr_seq_evento = b.nr_sequencia 
	and	upper(b.ds_evento) like upper('%Bactéria%') 
	and	coalesce(a.ie_situacao,'A') = 'A';


BEGIN 
 
select	max(ie_tipo_atendimento) 
into STRICT	ie_tipo_atendimento_w 
from	atendimento_paciente 
where	nr_atendimento = nr_atendimento_p;
 
if	((ie_tipo_atendimento_w = 1) or (ie_tipo_atendimento_w = 8) or (ie_tipo_atendimento_w = 3)) then 
	select	count(*) 
	into STRICT	qt_reg_w 
	from	atendimento_precaucao a, 
		atendimento_paciente b 
	where	a.nr_seq_motivo_isol = 4 
	and	a.nr_atendimento = b.nr_atendimento 
	and	b.cd_pessoa_fisica = cd_pessoa_fisica_p 
	and	b.cd_estabelecimento = cd_estabelecimento_p 
	and	b.ie_tipo_atendimento in (1,8,3) 
	and	b.nr_atendimento < nr_atendimento_p 
	and	trunc(trunc(clock_timestamp()) - trunc(a.dt_termino)) <= 90;
 
	qt_idade_w	:= coalesce(obter_idade_pf(cd_pessoa_fisica_p,clock_timestamp(),'A'),0);
 
	if (qt_reg_w >= 1) then 
		open C01;
		loop 
		fetch C01 into	 
			nr_seq_evento_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			CALL gerar_evento_paciente(nr_seq_evento_w,nr_atendimento_p,cd_pessoa_fisica_p,null,nm_usuario_p,null);
			end;
		end loop;
		close C01;
	end if;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evento_bac_multirresist ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

