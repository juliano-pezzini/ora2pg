-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_obs_conta_duplic ( nr_seq_protocolo_p pls_conta_imp.nr_seq_protocolo%type, nr_seq_segurado_conv_p pls_conta_imp.nr_seq_segurado_conv%type, nr_sequencia_p pls_conta_imp.nr_sequencia%type, cd_guia_operadora_conv_p pls_conta_imp.cd_guia_operadora_conv%type, dt_atendimento_conv_p pls_conta_imp.dt_atendimento_conv%type) RETURNS varchar AS $body$
DECLARE


ds_observacao_w		varchar(4000);

c01 CURSOR(nr_seq_protocolo_w		pls_conta_imp.nr_seq_protocolo%type,
            nr_seq_segurado_conv_w	pls_conta_imp.nr_seq_segurado_conv%type,
            nr_sequencia_w		pls_conta_imp.nr_sequencia%type,
            cd_guia_operadora_conv_w	pls_conta_imp.cd_guia_operadora_conv%type,
            dt_atendimento_conv_w	pls_conta_imp.dt_atendimento_conv%type)FOR
	SELECT	nr_sequencia
	from	pls_conta_imp c
	where	c.nr_seq_protocolo 	= nr_seq_protocolo_w
	and	c.nr_seq_segurado_conv	= nr_seq_segurado_conv_w
	and	c.nr_sequencia		<> nr_sequencia_w
	and	c.cd_guia_operadora_conv <> cd_guia_operadora_conv_w
	and 	c.dt_atendimento_conv	between inicio_dia(dt_atendimento_conv_w) and fim_dia(dt_atendimento_conv_w);


BEGIN

ds_observacao_w:= null;

for r_C01_w in C01(	nr_seq_protocolo_p,
                        nr_seq_segurado_conv_p,
                        nr_sequencia_p,
                        cd_guia_operadora_conv_p,
                        dt_atendimento_conv_p) loop
	begin

	ds_observacao_w:= ds_observacao_w || r_C01_w.nr_sequencia || ', ';

	end;
end loop;

if (coalesce(ds_observacao_w, 'X') <> 'X') then
	begin
	return	substr('Conta(s): ' || substr(ds_observacao_w, 1, length(ds_observacao_w) - 2),1, 4000);
	end;
else
	begin
	return null;
	end;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_obs_conta_duplic ( nr_seq_protocolo_p pls_conta_imp.nr_seq_protocolo%type, nr_seq_segurado_conv_p pls_conta_imp.nr_seq_segurado_conv%type, nr_sequencia_p pls_conta_imp.nr_sequencia%type, cd_guia_operadora_conv_p pls_conta_imp.cd_guia_operadora_conv%type, dt_atendimento_conv_p pls_conta_imp.dt_atendimento_conv%type) FROM PUBLIC;
