-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE get_ihc_mig ( nr_sequencia_p ihc_claim.nr_sequencia%type, nm_usuario_p ihc_claim.nm_usuario%type) AS $body$
DECLARE


vl_charge_w 		ihc_mig.vl_charge%type;
tx_service_w		ihc_mig.tx_service%type;	
qt_service_w		ihc_mig.qt_service%type;
ds_service_w		ihc_mig.ds_service%type;
dt_service_w		ihc_mig.dt_service%type;
cd_service_w		ihc_mig.cd_service%type;
nr_account_w		ihc_claim.nr_account%type;
vl_hospital_cid_w	ihc_claim.vl_hospital%type;
vl_charge_cid_w		ihc_claim.vl_charge%type;
ie_tipo_convenio_w 	convenio.ie_tipo_convenio%type;
check_w				integer := 0;
check_cd_proc_w		integer;
check_cd_proc1_w	integer;
check_cd_proc2_w	integer;
			
c01 CURSOR FOR
SELECT  coalesce(b.vl_procedimento,0) * 100,
		a.cd_procedimento_loc cd_procedimento,
		b.dt_procedimento,
		coalesce(b.tx_procedimento,0),
		b.qt_procedimento,
		substr(obter_descricao_procedimento(b.cd_procedimento, b.ie_origem_proced),1,30),
		d.ie_tipo_convenio
from    procedimento_paciente b,
		procedimento a,
		conta_paciente c,
		convenio d
where   b.nr_interno_conta = nr_account_w
and 	a.cd_procedimento = b.cd_procedimento
and		a.ie_origem_proced = b.ie_origem_proced
and 	c.nr_interno_conta 		= b.nr_interno_conta
and 	c.cd_convenio_parametro = d.cd_convenio
and 	((substr(b.cd_procedimento_convenio, 0, 2) in ('AP','DR','DS','DX','OH','OT','PX'))
		or (d.ie_tipo_convenio = 13));
			

BEGIN
	select  max(nr_account)
	into STRICT    nr_account_w
	from    ihc_claim
	where   nr_sequencia = nr_sequencia_p;
	
		begin
		open c01;
		loop
		fetch c01 into
			vl_charge_w,
			cd_service_w,
			dt_service_w,
			tx_service_w,
			qt_service_w,
			ds_service_w,
			ie_tipo_convenio_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */

		check_cd_proc_w := is_number(substr(cd_service_w, 0, 1));
		check_cd_proc1_w := is_number(substr(cd_service_w, 2, 1));
		check_cd_proc2_w := is_number(substr(cd_service_w, 3, 3));
		
		if (ie_tipo_convenio_w = 13) then
			if (check_cd_proc_w = 0 and (substr(cd_service_w, 0, 1) = 'M')
		      	or (check_cd_proc_w = 0 and check_cd_proc1_w = 0 and check_cd_proc2_w = 1)) then
		      check_w := 0;
		    else
		      check_w := 1;
		    end if;
		end if;
		
		if (billing_i18n_pck.get_validate_eclipse() = 'N' and check_w = 0) then

			insert into ihc_mig( 	vl_charge,
						ie_charge_raised,
						cd_service,
						dt_service,
						tx_service,
						qt_service,
						ds_service,
						nm_usuario,
						nm_usuario_nrec,
						dt_atualizacao,
						dt_atualizacao_nrec,
						nr_sequencia,
						nr_seq_claim)
					values ( vl_charge_w,
						CASE WHEN vl_charge_w=0 THEN 'I'  ELSE 'C' END ,
						cd_service_w,
						dt_service_w,
						tx_service_w,
						qt_service_w,
						ds_service_w,
						nm_usuario_p,
						nm_usuario_p,
						clock_timestamp(),
						clock_timestamp(),
						nextval('ihc_mig_seq'),
						nr_sequencia_p);

				if (vl_charge_w IS NOT NULL AND vl_charge_w::text <> '') then
					select  vl_hospital,
					        vl_charge
					into STRICT    vl_hospital_cid_w,
					        vl_charge_cid_w
					from    ihc_claim
					where   nr_sequencia = nr_sequencia_p;

					update  ihc_claim
					set     vl_hospital   = vl_hospital_cid_w + vl_charge_w,
					        vl_charge     = vl_charge_cid_w + vl_charge_w
					where   nr_sequencia  = nr_sequencia_p;

				end if;
		end if;		
		end loop;
		close c01;
		end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE get_ihc_mig ( nr_sequencia_p ihc_claim.nr_sequencia%type, nm_usuario_p ihc_claim.nm_usuario%type) FROM PUBLIC;

