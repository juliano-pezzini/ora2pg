-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gera_protocolo_assistencial (nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


-- Busca regras de protocolos assitencias para eventos associados
C01 CURSOR FOR
    SELECT	a.nr_sequencia                            nr_sequencia,
            buscar_total_associado(a.nr_sequencia)    qt_regras_assoc_obr,
            a.qt_regras_multiplas                     qt_regras_multiplas
    from	gqa_pendencia_regra a,
            gqa_pendencia       b
    where   b.nr_sequencia = a.nr_seq_pendencia
    and     a.ie_evento   = 4 
    and     a.ie_situacao = 'A'
    and     b.ie_situacao = 'A'
    and	    obter_se_gqa_regra_liberada(a.nr_sequencia) = 'S'
    order by 1;	

    nr_pend_prot_assist_w       bigint;
    nr_seq_protocolo_w          bigint;
    qt_regras_multiplas_w       bigint;
    qt_regras_assoc_obr_w       bigint;
    qt_total_obr_checado_w      bigint;
    qt_total_checado_w          bigint;
    nr_sequencia_w              bigint;

    dt_protocolo_assist_w       timestamp;
    dt_alta_w                   timestamp;

    cd_pessoa_fisica_w          varchar(10);
    cd_profisisonal_w          varchar(10);
	

BEGIN

if (coalesce(nr_atendimento_p, 0) > 0) then

    select  max(dt_alta)
    into STRICT    dt_alta_w
    from    atendimento_paciente
    where   nr_atendimento = nr_atendimento_p;
	
	if (coalesce(dt_alta_w::text, '') = '') then
        dt_protocolo_assist_w   := clock_timestamp();

        select 	obter_pf_usuario(nm_usuario_p,'C')
        into STRICT	cd_profisisonal_w
;

        cd_pessoa_fisica_w      := obter_pessoa_atendimento(nr_atendimento_p,'C');

    	open C01;
        loop
        fetch C01 into	
            nr_seq_protocolo_w,
            qt_regras_assoc_obr_w,
            qt_regras_multiplas_w;
        EXIT WHEN NOT FOUND; /* apply on C01 */
            begin

                select  nextval('protocolo_assistencial_seq')
                into STRICT    nr_pend_prot_assist_w
;

                insert into protocolo_assistencial(/*01*/
nr_sequencia,
                                                    /*02*/
dt_atualizacao,
                                                    /*03*/
nm_usuario,
                                                    /*04*/
nr_atendimento,
                                                    /*05*/
ie_situacao,
                                                    /*06*/
cd_profissional,
                                                    /*07*/
nm_usuario_status,
                                                    /*10*/
nr_seq_regra_gqa)
                        values (                     /*01*/
nr_pend_prot_assist_w,
                                                    /*02*/
dt_protocolo_assist_w,
                                                    /*03*/
nm_usuario_p,
                                                    /*04*/
nr_atendimento_p,
                                                    /*05*/
'A',
                                                    /*06*/
cd_profisisonal_w,
                                                    /*07*/
'A',
                                                    /*10*/
nr_seq_protocolo_w);

                commit;

                CALL gerar_regra_associada(nr_atendimento_p, nr_pend_prot_assist_w, nr_seq_protocolo_w, nm_usuario_p);

                -- Valida se atendeu as regras de total e total obrigatA³rio
                select sum(CASE WHEN b.ie_obrigatorio='S' THEN  1  ELSE 0 END ) qt_total_obr_checado, 
                       sum(1)                                   qt_total_checado
                into STRICT   qt_total_obr_checado_w,
                       qt_total_checado_w 
                from   protocolo_assist_item    a,
                       gqa_pendencia_regra_mult b,
                       gqa_pendencia_regra      c,
                       protocolo_assistencial   d
                where  c.nr_sequencia = b.nr_seq_regra
                and    d.nr_sequencia = a.nr_seq_protocolo
                and    d.nr_sequencia = nr_pend_prot_assist_w
                and    c.nr_sequencia = d.nr_seq_regra_gqa
                and    a.nr_seq_regra_gqa = b.nr_seq_regra_mult                
                and    a.ie_resultado = 'S';

                qt_total_obr_checado_w := coalesce(qt_total_obr_checado_w, 0);
                qt_total_checado_w := coalesce(qt_total_checado_w, 0);

                if (qt_total_obr_checado_w < qt_regras_assoc_obr_w) or (qt_total_checado_w < qt_regras_multiplas_w) then
                    
                    delete from protocolo_assist_item  where nr_seq_protocolo   = nr_pend_prot_assist_w;
                    delete from protocolo_assistencial where nr_sequencia       = nr_pend_prot_assist_w;

                else

                    select	nextval('gqa_pendencia_pac_seq')
                    into STRICT	nr_sequencia_w
;
					
					
                    insert into gqa_pendencia_pac(
                                    nr_sequencia,
                                    dt_atualizacao,
                                    nm_usuario,
                                    dt_atualizacao_nrec,
                                    nm_usuario_nrec,
                                    cd_pessoa_fisica,
                                    nr_atendimento,
                                    nr_seq_pend_regra,
                                    ie_assistencial,
                                    nr_seq_protocolo)
                    values (nr_sequencia_w,
                                    dt_protocolo_assist_w,
                                    nm_usuario_p,
                                    dt_protocolo_assist_w,
                                    nm_usuario_p,
                                    cd_pessoa_fisica_w,
                                    nr_atendimento_p,
                                    nr_seq_protocolo_w,
                                    'S',
                                    nr_pend_prot_assist_w);
					commit;
									
				   CALL gerar_consulta_reg_mentor(nm_usuario_p, null, nr_seq_protocolo_w, 4, nr_sequencia_w,null,null,null,null,nr_pend_prot_assist_w);
                   CALL GQA_GERAR_ACAO_REGRA(nr_seq_protocolo_w, nr_sequencia_w, nr_atendimento_p, cd_pessoa_fisica_w, nm_usuario_p);
                end if;

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
-- REVOKE ALL ON PROCEDURE gera_protocolo_assistencial (nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

