-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_atend_triagem ( nr_atendimento_p bigint, nm_usuario_p text, ie_inicio_triagem_p text DEFAULT 'N') AS $body$
DECLARE


cd_pessoa_fisica_w			varchar(10);
ie_clinica_w				varchar(5);
qt_horas_validade_w			bigint;
qt_reg_w				bigint;
dt_entrada_w				timestamp;
dt_inicio_triagem_w   timestamp := null;
nr_seq_pac_senha_fila_w			bigint;
nr_seq_fila_w				bigint;
nr_seq_queixa_w				bigint;
nr_seq_triagem_priori_w			bigint;
ie_tolife_w				    varchar(1) := 'N';
nr_seq_classif_w			varchar(10);
cd_procedencia_w			atendimento_paciente.cd_procedencia%type;


BEGIN

select coalesce(max('S'), 'N')
into STRICT   ie_tolife_w
from   to_life_log_importacao
where  nr_atendimento = nr_atendimento_p;

if (ie_inicio_triagem_p = 'GE') then
    dt_inicio_triagem_w := clock_timestamp();
end if;

if (ie_tolife_w = 'N') then

    qt_horas_validade_w		:= coalesce(obter_valor_param_usuario(916, 512, Obter_Perfil_Ativo, nm_usuario_p, coalesce( wheb_usuario_pck.get_cd_estabelecimento,0)),0);

    select	max(a.cd_pessoa_fisica),
        max(a.ie_clinica),
        max(a.dt_entrada),
        max(a.nr_seq_pac_senha_fila),
        max(a.NR_SEQ_QUEIXA),
        max(a.NR_SEQ_TRIAGEM_PRIORIDADE),
		max(a.CD_PROCEDENCIA)
    into STRICT	cd_pessoa_fisica_w,
        ie_clinica_w,
        dt_entrada_w,
        nr_seq_pac_senha_fila_w,
        nr_seq_queixa_w,
        nr_seq_triagem_priori_w,
		cd_procedencia_w
    from	atendimento_paciente a
    where	a.nr_atendimento = nr_atendimento_p
    and     not exists (SELECT 	1
                from   	triagem_pronto_atend b
                    where 	 b.nr_atendimento = nr_atendimento_p);

    select 	count(*)
    into STRICT	qt_reg_w
    from 	triagem_pronto_atend 
    where 	cd_pessoa_fisica = cd_pessoa_fisica_w
    and	dt_atualizacao_nrec between clock_timestamp() - (qt_horas_validade_w / 24) and clock_timestamp()
    and	coalesce(nr_atendimento::text, '') = '';

    if (nr_seq_queixa_w IS NOT NULL AND nr_seq_queixa_w::text <> '') and (Obter_se_Motivo_atend_Lib(nr_seq_queixa_w) = 'N') then
        nr_seq_queixa_w := null;	
    end if;

    if (nr_seq_pac_senha_fila_w IS NOT NULL AND nr_seq_pac_senha_fila_w::text <> '') then
        select	coalesce(nr_seq_fila_senha,nr_seq_fila_senha_origem) nr_fila
        into STRICT	nr_seq_fila_w
        from	paciente_senha_fila
        where	nr_sequencia = nr_seq_pac_senha_fila_w;
    end if;

    if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') and (qt_reg_w	= 0) then
		
		select OBTER_PRIORIDADE_TRIAGEM(nr_seq_queixa_w)
		into STRICT nr_seq_classif_w
		;

        insert into triagem_pronto_atend( nr_sequencia,
                            cd_pessoa_fisica,
                            ie_clinica,
                            nr_atendimento,
                            dt_inicio_triagem,
                            nm_usuario,
                            dt_atualizacao,
                            dt_atualizacao_nrec,
                            ie_status_paciente,
                            nr_seq_fila_senha,
                            nr_seq_pac_fila,
                            nr_seq_queixa,
                            NR_SEQ_TRIAGEM_PRIORIDADE,
							cd_procedencia,
			    nr_seq_classif,
			    nm_usuario_nrec)
                            values ( nextval('triagem_pronto_atend_seq'),
                            cd_pessoa_fisica_w,
                            ie_clinica_w,
                            nr_atendimento_p,
                            dt_inicio_triagem_w,
                            nm_usuario_p,
                            clock_timestamp(),
                            clock_timestamp(),
                            'P',
                            nr_seq_pac_senha_fila_w,
                            nr_seq_fila_w,
                            nr_seq_queixa_w,
                            nr_seq_triagem_priori_w,
							cd_procedencia_w,
			    CASE WHEN nr_seq_classif_w='N' THEN  null  ELSE nr_seq_classif_w END ,
			    nm_usuario_p);

				CALL GQA_GERAR_PROTOCOLO_ASSIST(nr_atendimento_p,10,nm_usuario_p);
    end if;

    commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_atend_triagem ( nr_atendimento_p bigint, nm_usuario_p text, ie_inicio_triagem_p text DEFAULT 'N') FROM PUBLIC;
