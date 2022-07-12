-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_data_limite (qt_ocorrencia_p integer, nr_seq_segurado_p pls_conta.nr_seq_segurado%type, dt_referencia_p pls_conta_proc.dt_procedimento%type, cd_atend_tiss_p pls_clinica.cd_tiss%type, dt_inicio_p timestamp, dt_fim_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'N';
qt_soma_w	pls_conta_proc.qt_procedimento%type	:= 0;

C01 CURSOR(nr_seq_segurado_pc		pls_conta.nr_seq_segurado%type,
	    dt_inicio_pc		timestamp,
	    dt_fim_pc			timestamp)FOR
	SELECT	a.qt_procedimento,
		a.dt_procedimento
	from	pls_conta_proc	a,
		pls_conta	b,
		pls_segurado	c,
		pls_clinica	d
	where	a.nr_seq_conta		= b.nr_sequencia
	and	b.nr_seq_segurado	= c.nr_sequencia
	and	c.nr_sequencia		= nr_seq_segurado_pc
	and	b.ie_status		= 'F'
	and	a.ie_tipo_despesa	= '3'
	and	b.nr_seq_clinica	= d.nr_sequencia
	and	d.cd_tiss		= '5'
	and	a.dt_procedimento_referencia  between coalesce(dt_inicio_pc,dt_referencia_p) and coalesce(dt_fim_pc,a.dt_procedimento_referencia);
BEGIN

if (cd_atend_tiss_p	= '5') then

	for r_c01_w in c01(nr_seq_segurado_p,dt_inicio_p, dt_fim_p) loop
		begin
		qt_soma_w := qt_soma_w + r_c01_w.qt_procedimento;

		if	((trunc(r_c01_w.dt_procedimento)) <= trunc(dt_referencia_p)) and (qt_soma_w > qt_ocorrencia_p ) then
			ds_retorno_w := 'S';
			exit;
		end if;

		end;
	end loop;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_data_limite (qt_ocorrencia_p integer, nr_seq_segurado_p pls_conta.nr_seq_segurado%type, dt_referencia_p pls_conta_proc.dt_procedimento%type, cd_atend_tiss_p pls_clinica.cd_tiss%type, dt_inicio_p timestamp, dt_fim_p timestamp) FROM PUBLIC;
