-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_qtdlanc_automatico ( nr_seq_procedimento_p bigint) AS $body$
DECLARE

 
 
nr_seq_regra_lanc_w		bigint;
qt_procedimento_w		double precision	:= 0;
nr_seq_proc_regra_w		bigint;
cd_proc_regra_w			bigint;
nr_seq_lanc_acao_w		integer;
ie_quantidade_w			varchar(1)	:= 'I';
cd_material_w			integer;
nr_seq_material_w		bigint;

dt_procedimento_w		timestamp;
dt_conta_w			timestamp;

qt_lancamento_w			regra_lanc_aut_pac.qt_lancamento%type;
qt_proc_rla_w			procedimento_paciente.qt_procedimento%type;
qt_mat_rla_w			material_atend_paciente.qt_material%type;
cd_convenio_w			convenio.cd_convenio%type;

 
C01 CURSOR FOR 
SELECT	nr_sequencia, 
	cd_procedimento, 
	nr_seq_lanc_acao, 
	nr_seq_regra_lanc, 
	qt_procedimento, 
	cd_convenio 
from	procedimento_paciente 
where	nr_seq_proc_princ	= nr_seq_procedimento_p 
and	(nr_seq_regra_lanc IS NOT NULL AND nr_seq_regra_lanc::text <> '');

C02 CURSOR FOR 
SELECT	nr_sequencia, 
	cd_material, 
	nr_seq_regra_lanc, 
	qt_material 
from	material_atend_paciente 
where	nr_seq_proc_princ	= nr_seq_procedimento_p 
and	(nr_seq_regra_lanc IS NOT NULL AND nr_seq_regra_lanc::text <> '');

C03 CURSOR FOR 
SELECT	nr_sequencia, 
	cd_procedimento, 
	nr_seq_regra_lanc 
from	procedimento_paciente 
where	nr_seq_proc_princ	= nr_seq_procedimento_p 
and	((dt_procedimento	<> dt_procedimento_w) or (dt_conta <> dt_conta_w)) 
and	(nr_seq_regra_lanc IS NOT NULL AND nr_seq_regra_lanc::text <> '');

C04 CURSOR FOR 
SELECT	nr_sequencia, 
	nr_seq_regra_lanc 
from	material_Atend_paciente 
where	nr_seq_proc_princ	= nr_seq_procedimento_p 
and	((dt_atendimento	<> dt_procedimento_w) or (dt_conta <> dt_conta_w)) 
and	(nr_seq_regra_lanc IS NOT NULL AND nr_seq_regra_lanc::text <> '');


BEGIN 
 
select	qt_procedimento, 
	dt_procedimento, 
	dt_conta 
into STRICT	qt_procedimento_w, 
	dt_procedimento_w, 
	dt_conta_w 
from	procedimento_paciente 
where	nr_sequencia	= nr_seq_procedimento_p;
 
OPEN C01;
LOOP 
FETCH C01 into 
	nr_seq_proc_regra_w, 
	cd_proc_regra_w, 
	nr_seq_lanc_acao_w, 
	nr_seq_regra_lanc_w, 
	qt_proc_rla_w, 
	cd_convenio_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	if (coalesce(nr_seq_lanc_acao_w,0) > 0) then 
		select	coalesce(max(ie_quantidade),'I'), 
			coalesce(max(qt_lancamento),1) 
		into STRICT	ie_quantidade_w, 
			qt_lancamento_w 
		from	regra_lanc_aut_pac 
		where	nr_seq_lanc	= nr_seq_lanc_acao_w 
		and	nr_seq_regra	= nr_seq_regra_lanc_w;
	else 
		select	coalesce(max(ie_quantidade),'I'), 
			coalesce(max(qt_lancamento),1) 
		into STRICT	ie_quantidade_w, 
			qt_lancamento_w 
		from	regra_lanc_aut_pac 
		where	cd_procedimento	= cd_proc_regra_w 
		and 	coalesce(ie_adic_orcamento,'N') = 'N' 
		and	nr_seq_regra	= nr_seq_regra_lanc_w;
	end if;
 
	if (ie_quantidade_w	= 'M') and 
		((qt_procedimento_w * coalesce(qt_lancamento_w,1)) <> qt_proc_rla_w) then 
		update	procedimento_paciente 
		set	qt_procedimento	= qt_procedimento_w * coalesce(qt_lancamento_w,1) 
		where	nr_sequencia	= nr_seq_proc_regra_w;
		 
		CALL atualiza_preco_procedimento(nr_seq_proc_regra_w, cd_convenio_w, wheb_usuario_pck.get_nm_usuario);
	end if;
	end;
END LOOP;
CLOSE C01;
 
OPEN C02;
LOOP 
FETCH C02 into 
	nr_seq_material_w, 
	cd_material_w, 
	nr_seq_regra_lanc_w, 
	qt_mat_rla_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin 
	select	coalesce(max(ie_quantidade),'I'), 
		coalesce(max(qt_lancamento),1) 
	into STRICT	ie_quantidade_w, 
		qt_lancamento_w 
	from	regra_lanc_aut_pac 
	where	cd_material	= cd_material_w 
	and 	coalesce(ie_adic_orcamento,'N') = 'N' 
	and	nr_seq_regra	= nr_seq_regra_lanc_w;
 
	if (ie_quantidade_w	= 'M') and 
		((qt_procedimento_w * coalesce(qt_lancamento_w,1)) <> qt_mat_rla_w) then 
		update	material_atend_paciente 
		set	qt_material	= qt_procedimento_w * coalesce(qt_lancamento_w,1) 
		where	nr_sequencia	= nr_seq_material_w;
		 
		CALL atualiza_preco_material(nr_seq_material_w, wheb_usuario_pck.get_nm_usuario);
	end if;
	end;
END LOOP;
CLOSE C02;
 
OPEN C03;
LOOP 
FETCH C03 into 
	nr_seq_proc_regra_w, 
	cd_proc_regra_w, 
	nr_seq_regra_lanc_w;
EXIT WHEN NOT FOUND; /* apply on c03 */
	begin 
 
	update	procedimento_paciente 
	set	dt_procedimento	= dt_procedimento_w, 
		dt_conta	= dt_conta_w 
	where	nr_sequencia	= nr_seq_proc_regra_w;
	 
	end;
END LOOP;
CLOSE C03;
 
OPEN C04;
LOOP 
FETCH C04 into 
	nr_seq_material_w, 
	nr_seq_regra_lanc_w;
EXIT WHEN NOT FOUND; /* apply on c04 */
	begin 
 
	update	material_atend_paciente 
	set	dt_atendimento	= dt_procedimento_w, 
		dt_conta	= dt_conta_w 
	where	nr_sequencia	= nr_seq_material_w;
	 
	end;
END LOOP;
CLOSE C04;
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_qtdlanc_automatico ( nr_seq_procedimento_p bigint) FROM PUBLIC;

