-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_interf_conta_grg ( nr_seq_analise_p bigint, nm_usuario_p text, ds_protocolo_p INOUT text ) AS $body$
DECLARE


nr_interno_conta_w	lote_audit_hist_guia.nr_interno_conta%type;

nr_seq_propaci_w	lote_audit_hist_item.nr_seq_propaci%type;
nr_seq_matpaci_w	lote_audit_hist_item.nr_seq_matpaci%type;
vl_amenor_w		lote_audit_hist_item.vl_amenor%type;

nr_seq_intef_w		w_interf_conta_item.nr_sequencia%type;
nr_seq_item_w		w_interf_conta_item.nr_seq_item%type;

nr_seq_protocolo_w	conta_paciente.nr_seq_protocolo%type;

vl_custo_operacional_w	procedimento_paciente.vl_custo_operacional%type;
vl_medico_w		procedimento_paciente.vl_medico%type;
vl_procedimento_w	procedimento_paciente.vl_procedimento%type;
tx_custo_oper_w		double precision;
tx_honorario_w		double precision;


ds_protocolo_w		varchar(2000);
ie_prot_exists_w	integer;

cAuditGuiaItem CURSOR FOR
SELECT 	a.nr_interno_conta,
        b.nr_seq_propaci,
		b.nr_seq_matpaci,
		b.vl_amenor
from 	lote_audit_hist_guia a,
        lote_audit_hist_item b
where 	a.nr_seq_lote_hist = nr_seq_analise_p
and     b.nr_seq_guia = a.nr_sequencia;


BEGIN

	open	cAuditGuiaItem;
		loop
			fetch	cAuditGuiaItem into
				nr_interno_conta_w,
				nr_seq_propaci_w,
				nr_seq_matpaci_w,
				vl_amenor_w;
			EXIT WHEN NOT FOUND; /* apply on cAuditGuiaItem */

			begin

				select	max(nr_seq_protocolo)
				into STRICT	nr_seq_protocolo_w
				from	conta_paciente
				where	nr_interno_conta = nr_interno_conta_w;

				select	position(nr_seq_protocolo_w in ds_protocolo_w)
				into STRICT	ie_prot_exists_w
				;

				if ie_prot_exists_w <1 or coalesce(ie_prot_exists_w::text, '') = '' then
					ds_protocolo_w	:= ds_protocolo_w || nr_seq_protocolo_w || ', ';
				end if;

				nr_seq_intef_w := 0;

				select	max(nr_sequencia),
					max(nr_seq_item)
				into STRICT 	nr_seq_intef_w,
					nr_seq_item_w
				from	w_interf_conta_item
				where	nr_seq_item = coalesce(nr_seq_propaci_w, 0);

				if nr_seq_intef_w > 0 then
					tx_custo_oper_w := 1;
					tx_honorario_w := 1;
					
					select 	max(vl_custo_operacional),
						max(vl_medico),
						max(vl_procedimento)
					into STRICT	vl_custo_operacional_w,
						vl_medico_w,
						vl_procedimento_w
					from	procedimento_paciente
					where	nr_sequencia = nr_seq_item_w;
					
					if (vl_custo_operacional_w > 0 and vl_procedimento_w > 0) then
						tx_custo_oper_w := round((vl_custo_operacional_w / vl_procedimento_w)::numeric,4);

					end if;
					
					if (vl_medico_w > 0 and vl_procedimento_w > 0) then
						tx_honorario_w := round((vl_medico_w / vl_procedimento_w)::numeric,4);
					end if;

					update	w_interf_conta_item
					set 	vl_total_item = vl_amenor_w,
						vl_honorario = round((vl_amenor_w * tx_honorario_w)::numeric,2),
						vl_custo_oper = round((vl_amenor_w * tx_custo_oper_w)::numeric,2),
                                                nm_usuario = nm_usuario_p,
                                                cd_tipo_registro = 1
					where	nr_sequencia = nr_seq_intef_w;

				end if;

				nr_seq_intef_w := 0;

				select	max(nr_sequencia)
				into STRICT 	nr_seq_intef_w
				from	w_interf_conta_item
				where	nr_seq_item = coalesce(nr_seq_matpaci_w, 0);

				if nr_seq_intef_w > 0 then

					update	w_interf_conta_item
					set 	vl_total_item = vl_amenor_w,
                                                nm_usuario = nm_usuario_p,
                                                cd_tipo_registro = 1
					where	nr_sequencia = nr_seq_intef_w;
					
				end if;

			end;

		end loop;
	close	cAuditGuiaItem;
	delete from w_interf_conta_item where (cd_tipo_registro <> 1 or (vl_total_item = 0 and cd_tipo_registro = 1));
	commit;

	ds_protocolo_p	:= substr(ds_protocolo_w, 1, length(ds_protocolo_w) - 2);

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_interf_conta_grg ( nr_seq_analise_p bigint, nm_usuario_p text, ds_protocolo_p INOUT text ) FROM PUBLIC;
