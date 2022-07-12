-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prioridade_leg_agenda ( nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


ds_cor_w		varchar(15);
nr_seq_prioridade_w	bigint;
ie_status_agenda_w	varchar(3);
ie_tipo_classif_w	bigint;
ie_status_legenda_w	varchar(15);
dt_agendamento_w	timestamp;
dt_confirmacao_w	timestamp;
qt_internado_w		bigint := 0;
cd_pessoa_fisica_w	varchar(10);
ds_precaucao_w		varchar(255);
ie_autor_desdobrada_w	varchar(1);
ie_autorizacao_w	varchar(3);
nr_atendimento_w	bigint;
ie_encaixe_w		varchar(1);
ja_leu_w		varchar(1) := 'N';
nr_sequencia_w		        agenda_paciente.nr_sequencia%type;
ie_possui_ag_ex_w varchar(1) := 'N';
dt_agenda_w		timestamp;

C01 CURSOR FOR
	SELECT	ie_status_legenda,
		ds_cor,
		nr_seq_prioridade
	from	regra_legenda_agenda
	order by nr_seq_prioridade desc;
	

BEGIN

ie_autorizacao_w := Obter_Param_Usuario(871, 514, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_autorizacao_w);

if (coalesce(ie_autorizacao_w,'N') = 'N') then
	goto final;
end if;

open C01;
loop
fetch C01 into	
	ie_status_legenda_w,
	ds_cor_w,
	nr_seq_prioridade_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	if (ja_leu_w <> 'S') then
		select 	max(ie_status_agenda),
			max(ie_autorizacao),
			max(nr_sequencia),
			max(dt_agendamento),
			max(dt_confirmacao),
			max(cd_pessoa_fisica),
			max(nr_atendimento),
			max(dt_agenda)
		into STRICT 	ie_status_agenda_w,
			ie_autorizacao_w,
			nr_sequencia_w,
			dt_agendamento_w,
			dt_confirmacao_w,
			cd_pessoa_fisica_w,
			nr_atendimento_w,
			dt_agenda_w
		from 	agenda_paciente
		where 	nr_sequencia = nr_seq_agenda_p;
		ja_leu_w := 'S';
	end if;	
	
	if (ie_status_legenda_w = 'LI') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'PS') and (ie_status_agenda_w = 'PS') then
		ds_cor_w := ds_cor_w;
		goto final;	
	elsif (ie_status_legenda_w = 'N') and (ie_status_agenda_w = 'N') then
		ds_cor_w := ds_cor_w;
		goto final;	
	elsif (ie_status_legenda_w = 'IN') and (ie_status_agenda_w = 'IN') then
		ds_cor_w := ds_cor_w;
		goto final;	
	elsif (ie_status_legenda_w = 'RX') and (ie_status_agenda_w = 'RE') then
		ds_cor_w := ds_cor_w;
		goto final;	
	elsif (ie_status_legenda_w = 'AA') and (ie_status_agenda_w = 'AT') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'A') and (ie_status_agenda_w = 'A') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'AD') and (obter_se_autor_desdob_agenda(nr_sequencia_w) = 'S')  then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'AG') and (dt_agendamento_w IS NOT NULL AND dt_agendamento_w::text <> '') and (ie_status_agenda_w <> 'PA') and (ie_status_agenda_w <> 'PC')  and (ie_status_agenda_w <> 'R')  and (ie_status_agenda_w <> 'E') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'AI') and (ie_autorizacao_w = 'AI') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'AU') and (ie_autorizacao_w = 'A') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'O') and (ie_status_agenda_w = 'O') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'KP') and (ie_status_agenda_w = 'KP') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'F') and (ie_status_agenda_w = 'F') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'M') and (ie_status_agenda_w = 'M') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'LF') and (ie_status_agenda_w = 'LF') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'PP') and (ie_autorizacao_w = 'PA') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'AN') and (ie_status_agenda_w = 'AN') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'AC') and (ie_status_agenda_w = 'AC') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'II') and (ie_status_agenda_w = 'II') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'EE') and (ie_status_agenda_w = 'EE') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'PF') and (ie_status_agenda_w = 'PF') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'ET') and (ie_status_agenda_w = 'ET') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'AR') and (ie_status_agenda_w = 'AR') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'RV') and (ie_status_agenda_w = 'RV') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'AE') and (ie_status_agenda_w = 'AE') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'S') and (ie_status_agenda_w = 'S') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'BL') and (ie_status_agenda_w = 'B') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'C') and (ie_status_agenda_w = 'C') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'PF') and (ie_status_agenda_w = 'PF') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'CN') and (dt_confirmacao_w IS NOT NULL AND dt_confirmacao_w::text <> '') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'EN') and (Obter_Se_Agenda_Encaixe(nr_sequencia_w) = 'S') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'PA') and (ie_autorizacao_w = 'PA') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'EX') and (ie_status_agenda_w = 'E') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'FJ') and (ie_status_agenda_w = 'I') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'IP') and (ie_status_agenda_w = 'IP') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'CA') and (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
		ds_cor_w := ds_cor_w;
		goto final;	
	elsif (ie_status_legenda_w = 'CR') and (ie_status_agenda_w = 'CR') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'PRO') and (ie_status_agenda_w = 'PR') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'PO') and (ie_status_agenda_w = 'PO') then
		ds_cor_w := ds_cor_w;
		goto final;	
	elsif (ie_status_legenda_w = 'PI') and (ie_autorizacao_w = 'PA') then

		select	count(*) 
		into STRICT 	qt_internado_w
		from    setor_atendimento c, 
			atendimento_paciente b, 
			unidade_atendimento a 
                where   a.nr_atendimento        = b.nr_atendimento 
                and     a.cd_setor_atendimento  = c.cd_setor_atendimento 
                and     c.cd_classif_setor      in (3,4,8) 
                and     b.cd_pessoa_fisica      = cd_pessoa_fisica_w;

		if (qt_internado_w > 0) then
			ds_cor_w := ds_cor_w;
			goto final;
		end if;
	elsif (ie_status_legenda_w = 'PC') and (ie_status_agenda_w = 'PC') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'PA') and (ie_status_agenda_w = 'PA') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'PA') and (ie_status_agenda_w = 'PA') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'PR') and (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') and (substr(obter_desc_precaucao(nr_atendimento_w),1,255) is not null) then
		ds_cor_w := ds_cor_w;
		goto final;	
	elsif (ie_status_legenda_w = 'RP') and (ie_autorizacao_w = 'B') then
		ds_cor_w := ds_cor_w;
		goto final;	
	elsif (ie_status_legenda_w = 'RE') and (ie_status_agenda_w = 'R') then
		ds_cor_w := ds_cor_w;
		goto final;	
	elsif (ie_status_legenda_w = 'RG') and (ie_status_agenda_w = 'RG') then
		ds_cor_w := ds_cor_w;
		goto final;	
	elsif (ie_status_legenda_w = 'RN') and (ie_status_agenda_w = 'RN') then
		ds_cor_w := ds_cor_w;
		goto final;	
	elsif (ie_status_legenda_w = 'P') and (ie_autorizacao_w = 'P') then
		ds_cor_w := ds_cor_w;
		goto final;
	elsif (ie_status_legenda_w = 'NN') and (ie_autorizacao_w = 'NN') then
		ds_cor_w := ds_cor_w;
		goto final;		
	elsif (ie_status_legenda_w = 'NG') and (ie_autorizacao_w = 'N') then
		ds_cor_w := ds_cor_w;
		goto final;	
	elsif (ie_status_legenda_w = 'AP') and (ie_status_agenda_w = 'AP') then
		ds_cor_w := ds_cor_w;
		goto final;			
	elsif (ie_status_legenda_w = 'AGE') then
			SELECT 	coalesce(MAX('S'),'N')
			INTO STRICT 	ie_possui_ag_ex_w
			FROM 	agenda_paciente a,
					agenda b
			WHERE 	a.cd_agenda = b.cd_agenda
			AND 	b.cd_tipo_agenda 	= 2
			AND 	a.ie_status_agenda NOT IN ('C','L','B')
			AND 	a.cd_pessoa_fisica 	= cd_pessoa_fisica_w
			AND 	TRUNC(a.dt_agenda) 	= TRUNC(dt_agenda_w);
			
			if (ie_possui_ag_ex_w = 'S') then
				ds_cor_w := ds_cor_w;
				goto final;
			end if;
	
	end if;

end;
end loop;
close C01;

<<final>>

return	ds_cor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prioridade_leg_agenda ( nr_seq_agenda_p bigint) FROM PUBLIC;
