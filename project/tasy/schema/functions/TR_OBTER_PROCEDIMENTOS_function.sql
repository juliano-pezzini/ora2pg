-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tr_obter_procedimentos (NR_SEQ_SOLICITACAO_P bigint) RETURNS varchar AS $body$
DECLARE


DS_PROCED_W			varchar(255);
DS_RETORNO_W		varchar(4000);
NR_ATENDIMENTO_W 	atendimento_paciente.nr_atendimento%type;
NR_PRESCRICAO_W 	PRESCR_MEDICA.NR_PRESCRICAO%type;
ds_disp_instalado_w varchar(1);

C01 CURSOR FOR
	SELECT substr(Obter_Desc_Prescr_Proc(cd_procedimento,ie_origem_proced,nr_seq_proc_interno,'S'),1,255)
	FROM   TRANS_SOLIC_PROCEDIMENTO
	WHERE  NR_SEQ_SOLICITACAO = NR_SEQ_SOLICITACAO_P
	ORDER BY NR_SEQ_SOLICITACAO;

C02 CURSOR FOR
	SELECT	substr(Obter_Desc_Prescr_Proc(PP.CD_PROCEDIMENTO, PP.IE_ORIGEM_PROCED, PP.NR_SEQ_PROC_INTERNO),1,255) DS_PROCED
	FROM	PRESCR_MEDICA PM,
			PRESCR_PROCEDIMENTO PP
	WHERE	NR_ATENDIMENTO = NR_ATENDIMENTO_W
	AND		Obter_se_prescr_vigente(PP.NR_PRESCRICAO) = 'S'
	AND 	PM.NR_PRESCRICAO = PP.NR_PRESCRICAO;


BEGIN
ds_disp_instalado_w := obter_param_usuario(10050, 12, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ds_disp_instalado_w);

IF (NR_SEQ_SOLICITACAO_P IS NOT NULL AND NR_SEQ_SOLICITACAO_P::text <> '') THEN
	OPEN C01;
	LOOP
	FETCH C01 INTO	
		DS_PROCED_W;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		BEGIN
			DS_RETORNO_W := substr(DS_RETORNO_W||' - '||DS_PROCED_W,1,4000);
		END;
	END LOOP;
	CLOSE C01;

	if (coalesce(ds_disp_instalado_w,'N') = 'S') then
		begin
			select	nr_atendimento
			into STRICT	nr_atendimento_w
			from	trans_solicitacao
			where	nr_sequencia = nr_seq_solicitacao_p
			and 	coalesce(nr_atendimento,0) > 0;
		exception when others then
			nr_atendimento_w := 0;
		end;

		IF (NR_ATENDIMENTO_W > 0) THEN

			DS_PROCED_W := '';
			OPEN C02;
			LOOP
			FETCH C02 INTO	
				DS_PROCED_W;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				BEGIN
					DS_RETORNO_W := substr(DS_RETORNO_W||' - '||DS_PROCED_W,1,4000);
				END;
			END LOOP;
			CLOSE C02;

		END IF;
 	end if;
end if;

RETURN	SUBSTR(DS_RETORNO_W,3,4000);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tr_obter_procedimentos (NR_SEQ_SOLICITACAO_P bigint) FROM PUBLIC;
