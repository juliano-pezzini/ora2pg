-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nais_mla_treatunexe.send_internalproc_message ( nr_prescricao_p bigint, cd_classif_p text, file_output_p INOUT text ) AS $body$
DECLARE

    c_order_unit varchar(100);
    json_output_list_w philips_json_list;
    json_output_w		  philips_json;
    nr_seq_int_call_log_w bigint :=0;
    ds_log_message_w      varchar(500);
    nr_atendimento_w cpoe_procedimento.nr_atendimento%type;

    c04 CURSOR FOR 
     SELECT distinct co.nr_order_unit order_unit
     from   cpoe_procedimento a,         
            prescr_procedimento b,
            proc_interno pi,
            cpoe_order_unit co,
            cpoe_tipo_pedido cp
     where  a.nr_sequencia = b.nr_seq_proc_cpoe 
     and    pi.nr_sequencia = a.nr_seq_proc_interno
     and    b.nr_prescricao = nr_prescricao_p 
     and    co.nr_seq_cpoe_tipo_pedido   = cp.nr_sequencia
     and    co.nr_sequencia              = a.nr_seq_cpoe_order_unit
     and    cp.nr_seq_sub_grp            = 'PC'
     and    obter_conversao_externa_int(null,'PROC_INTERNO_CLASSIF','NR_SEQUENCIA', pi.nr_seq_classif, 'NAIS' ) = 'P0'
     order by co.nr_order_unit asc;


      
BEGIN
       json_output_w   := philips_json();
       json_output_list_w	:= philips_json_list();
        open c04;
          loop
                fetch c04 into c_order_unit;
                EXIT WHEN NOT FOUND; /* apply on c04 */
                file_output_p := nais_mla_treatunexe.send_intprofs_data(nr_prescricao_p, cd_classif_p, c_order_unit);
                json_output_w := nais_mla_treatunexe.add_json_value(json_output_w, 'message', current_setting('nais_mla_treatunexe.ds_line_w')::varchar(32767));
                json_output_list_w.append(json_output_w.to_json_value());
          end loop;
        dbms_lob.createtemporary( file_output_p, true);
        json_output_list_w.(file_output_p);
        record_integration_call_log(coalesce(wheb_usuario_pck.get_nm_usuario , 'NAIS'), 'NAIS', clock_timestamp(), cd_classif_p, cd_classif_p ,    --Success Logger
        'T', 'E', null, 'MJ', file_output_p,null, 0,nr_seq_int_call_log_w, 0, 944,'S');
        close c04;

      END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nais_mla_treatunexe.send_internalproc_message ( nr_prescricao_p bigint, cd_classif_p text, file_output_p INOUT text ) FROM PUBLIC;