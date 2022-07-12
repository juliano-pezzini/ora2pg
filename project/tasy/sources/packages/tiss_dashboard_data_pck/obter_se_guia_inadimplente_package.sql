-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tiss_dashboard_data_pck.obter_se_guia_inadimplente (nr_interno_conta_p conta_paciente.nr_interno_conta%type, cd_autorizacao_p autorizacao_convenio.cd_autorizacao%type, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_inadimplente_w varchar(1) := 'N';
qt_w bigint;



BEGIN
	if (clock_timestamp() > coalesce(dt_referencia_p,clock_timestamp())) then

		select 	count(a.nr_sequencia) qt
		into STRICT	qt_w
		from	convenio_retorno_item a,
			convenio_retorno b
		where	a.nr_seq_retorno = b.nr_sequencia
		and	a.nr_interno_conta 	= nr_interno_conta_p
		and	coalesce(a.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738)) 	= cd_autorizacao_p
		and	b.dt_retorno 		> dt_referencia_p;

		if  qt_w = 0 then
			select  count(a.nr_sequencia) qt
			into STRICT	qt_w
			from	lote_audit_hist_guia a,
			    lote_audit_hist b,
			    lote_auditoria c
			where	a.nr_seq_lote_hist 	= b.nr_sequencia
			and	    b.nr_seq_lote_audit 	= c.nr_sequencia
			and	    c.dt_lote		> dt_referencia_p
			and	    a.nr_interno_conta 	= nr_interno_conta_p
			and	    coalesce(a.cd_autorizacao, wheb_mensagem_pck.get_texto(1097738)) 	= cd_autorizacao_p;
		
		end if;

		if qt_w = 0 then

			select 	count(nr_sequencia) qt
			into STRICT	qt_w
			from	tiss_dem_conta
			where	nr_interno_conta 	= nr_interno_conta_p
			and	nr_guia_operadora 	= cd_autorizacao_p
			and	dt_atualizacao_nrec 	< dt_referencia_p;

		end if;
			

		if  qt_w = 0 then
		
			ie_inadimplente_w := 'S';
		
		end if;

	end if;

	return coalesce(ie_inadimplente_w, 'N');

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tiss_dashboard_data_pck.obter_se_guia_inadimplente (nr_interno_conta_p conta_paciente.nr_interno_conta%type, cd_autorizacao_p autorizacao_convenio.cd_autorizacao%type, dt_referencia_p timestamp) FROM PUBLIC;