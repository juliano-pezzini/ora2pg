-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION qsm_status_pck.get_qa_all_status_request ( nr_seq_fila_p bigint, nr_episodio_p bigint) RETURNS SETOF T_STATUS AS $body$
DECLARE


C01 CURSOR FOR
	SELECT 	coalesce(ep.nr_episodio, a.nr_seq_episodio) ds_case,
			c.cd_estabelecimento ds_client
	from 	wl_worklist a,
			wl_item b,
			atendimento_paciente c,
			episodio_pac_document d,
            episodio_paciente ep
	where 	a.nr_seq_item = b.nr_sequencia
	and		c.nr_seq_episodio = a.nr_seq_episodio
	and		a.nr_seq_document = d.nr_sequencia
    and     ep.nr_sequencia = c.nr_seq_episodio
	and	  	b.cd_categoria = 'QA'
	and   	coalesce(a.dt_final_real::text, '') = ''
	and		((a.nr_seq_episodio = nr_episodio_p) or (coalesce(nr_episodio_p::text, '') = ''))
	group by coalesce(ep.nr_episodio, a.nr_seq_episodio), c.cd_estabelecimento;

nr_seq_documento_w		intpd_fila_transmissao.nr_seq_documento%type;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_regra_w			intpd_eventos_sistema.nr_seq_regra_conv%type;
nr_seq_episodio_w		episodio_paciente.nr_sequencia%type;
r_status_w			r_status;

BEGIN
select	a.nr_seq_documento,
	coalesce(b.ie_conversao,'I'),
	b.nr_seq_regra_conv
into STRICT	nr_seq_documento_w,
	ie_conversao_w,
	nr_seq_regra_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia		= nr_seq_fila_p;

for r_C01_w in C01 loop
	begin
	r_status_w := qsm_status_pck.limpar_atributos_status(r_status_w);

	r_status_w.ds_case		:= r_C01_w.ds_case;
	r_status_w.ds_client	:= intpd_conv('ESTABELECIMENTO', 'CD_ESTABELECIMENTO', r_C01_w.ds_client, nr_seq_regra_w, ie_conversao_w, 'E');

	RETURN NEXT r_status_w;
	end;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION qsm_status_pck.get_qa_all_status_request ( nr_seq_fila_p bigint, nr_episodio_p bigint) FROM PUBLIC;
