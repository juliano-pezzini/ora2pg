-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_laudo_sus_aih ( nr_sequencia_p bigint) AS $body$
DECLARE

 
 
 
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
qt_procedimento_w	double precision;
ie_tipo_laudo_sus_w 	varchar(20);
ie_obrigatorio_w	varchar(20);
nr_atendimento_w	bigint;
qt_sus_laudo_w		bigint;
qt_laudos_w		bigint;
cd_medico_w		varchar(10);
cd_medico_responsavel_w	varchar(10);
cd_medico_atend_w	varchar(10);
nr_aih_w		bigint;
nr_laudo_w		smallint;
dt_entrada_w		timestamp;
nr_interno_conta_w	bigint;
nm_usuario_w		varchar(15);
nr_seq_interno_w	bigint;


BEGIN 
 
select	cd_procedimento, 
	ie_origem_proced, 
	qt_procedimento, 
	nr_atendimento, 
	cd_medico_executor, 
	nr_interno_conta, 
	nm_usuario 
into STRICT	cd_procedimento_w, 
	ie_origem_proced_w, 
	qt_procedimento_w, 
	nr_atendimento_w, 
	cd_medico_w, 
	nr_interno_conta_w, 
	nm_usuario_w 
from	procedimento_paciente 
where	nr_sequencia	= nr_sequencia_p;
 
select	dt_entrada, 
	cd_medico_resp 
into STRICT	dt_entrada_w, 
	cd_medico_atend_w 
from	atendimento_paciente 
where	nr_atendimento = nr_atendimento_w;
 
select	nextval('sus_laudo_paciente_seq') 
into STRICT	nr_seq_interno_w
;
 
SELECT * FROM Obter_Tipo_Laudo_Sus(cd_procedimento_w, ie_origem_proced_w, ie_tipo_laudo_sus_w, ie_obrigatorio_w) INTO STRICT ie_tipo_laudo_sus_w, ie_obrigatorio_w;
 
if (ie_tipo_laudo_sus_w IS NOT NULL AND ie_tipo_laudo_sus_w::text <> '') and (ie_obrigatorio_w = 'S') then 
	begin 
	select	count(*) 
	into STRICT	qt_sus_laudo_w 
	from	sus_laudo_paciente 
	where	nr_atendimento		= nr_atendimento_w 
	and	nr_interno_conta	= nr_interno_conta_w 
	and	ie_tipo_laudo_sus in (ie_tipo_laudo_sus_w) 
	and	((coalesce(cd_procedimento_solic::text, '') = '') or (cd_procedimento_solic = cd_procedimento_w)) 
	and	ie_origem_proced	= 2;
 
	if (qt_sus_laudo_w	= 0) then 
		begin 
		begin 
		select	nr_aih, 
			cd_medico_responsavel 
		into STRICT	nr_aih_w, 
			cd_medico_responsavel_w 
		from	sus_aih 
		where	nr_interno_conta	= nr_interno_conta_w;
		exception 
			when others then 
			nr_aih_w		:= null;
			cd_medico_responsavel_w	:= null;
		end;
 
		if (cd_medico_w = '') and (cd_medico_responsavel_w <> '') then 
			cd_medico_w	:= cd_medico_responsavel_w;
		else 
			cd_medico_w	:= cd_medico_atend_w;
		end if;
	 
		if (Length(ie_tipo_laudo_sus_w) <= 2) and (position(',' in ie_tipo_laudo_sus_w) <= 0) then 
			begin 
			select	coalesce(MAX(nr_laudo_sus),0) + 1 
			into STRICT	nr_laudo_w	 
			from	sus_laudo_paciente 
			where	nr_atendimento	= nr_atendimento_w;
 
			select	count(*) 
			into STRICT	qt_laudos_w 
			from	sus_laudo_paciente 
			where	not ie_tipo_laudo_sus in (0,1) 
			and	nr_atendimento	= nr_atendimento_w;
 
			if (qt_laudos_w < 5) then 
				begin 
				insert into sus_laudo_paciente( 
						NR_ATENDIMENTO, 
						IE_TIPO_LAUDO_SUS, 
						NR_LAUDO_SUS, 
						DT_EMISSAO, 
						CD_PROCEDIMENTO_SOLIC, 
						IE_ORIGEM_PROCED, 
						QT_PROCEDIMENTO_SOLIC, 
						CD_MEDICO_REQUISITANTE, 
						CD_MEDICO_RESPONSAVEL, 
						DT_ATUALIZACAO, 
						NM_USUARIO, 
						DT_DIAGNOSTICO, 
						DS_MOTIVO_INTERNACAO, 
						DS_MOTIVO_ALTERACAO, 
						NR_AIH, 
						NR_INTERNO_CONTA, 
						ie_diaria_acomp, 
						nr_seq_interno) 
					values ( nr_atendimento_w, 
						ie_tipo_laudo_sus_w, 
						nr_laudo_w, 
						dt_entrada_w, 
						cd_procedimento_w, 
						2, 
						qt_procedimento_w, 
						cd_medico_w, 
						cd_medico_responsavel_w, 
						clock_timestamp(), 
						'Tasy', 
						null, 
						null, 
						null, 
						nr_aih_w,	 
						nr_interno_conta_w, 
						'N', 
						nr_seq_interno_w);
				end;
			end if;
			end;
		end if;
	 
		if (Length(ie_tipo_laudo_sus_W) > 2) then 
			begin 
			insert into sus_laudo_paciente( 
					CD_PROCEDIMENTO_SOLIC, 
					IE_ORIGEM_PROCED, 
					CD_MEDICO_REQUISITANTE, 
					QT_PROCEDIMENTO_SOLIC, 
					NR_AIH,	 
					CD_MEDICO_RESPONSAVEL, 
					NR_ATENDIMENTO, 
					IE_TIPO_LAUDO_SUS, 
					NR_LAUDO_SUS, 
					DT_EMISSAO, 
					DT_ATUALIZACAO, 
					NM_USUARIO, 
					NR_SEQ_INTERNO, 
					NR_ATENDIMENTO_ORIGEM, 
					IE_STATUS_PROCESSO, 
					IE_CLASSIFICACAO, 
					IE_TRATAMENTO_ANT, 
					IE_CONTINUIDADE_TRAT, 
					IE_DIARIA_ACOMP) 
				values ( cd_procedimento_w, 
					2, 
					cd_medico_w, 
					qt_procedimento_w, 
					nr_aih_w, 
					cd_medico_responsavel_w, 
					nr_atendimento_w, 
					0, 
					nr_laudo_w, 
					dt_entrada_w, 
					clock_timestamp(), 
					nm_usuario_w, 
					nr_seq_interno_w, 
					nr_atendimento_w, 
					1, 
					1, 
					'N', 
					'N', 
					'N');	
			end;
		end if;
		end;
	end if;	
	end;
end if;
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_laudo_sus_aih ( nr_sequencia_p bigint) FROM PUBLIC;

