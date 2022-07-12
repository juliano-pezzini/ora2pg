-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
'_-rzvish_-caseModifyBirth'
*/
CREATE OR REPLACE FUNCTION ish_rzv_birth_pck.get_case_modify_birth (nr_seq_fila_p bigint) RETURNS SETOF T_CASE_MODIFY_BIRTH AS $body$
DECLARE


r_case_modify_birth_w		r_case_modify_birth;

reg_integracao_w			gerar_int_padrao.reg_integracao_conv;
nr_seq_documento_w		intpd_fila_transmissao.nr_seq_documento%type;
nr_atendimento_w			nascimento.nr_atendimento%type;
nr_sequencia_w			nascimento.nr_sequencia%type;

nr_episodio_w			episodio_paciente.nr_episodio%type;
nr_episodio_rn_w			episodio_paciente.nr_episodio%type;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	b.nr_atendimento,
	b.nr_seq_episodio,
	a.nr_atend_rn,
	c.nr_seq_episodio nr_seq_episodio_rn,
	b.cd_estabelecimento,
	d.cd_empresa
FROM estabelecimento d, atendimento_paciente b, nascimento a
LEFT OUTER JOIN atendimento_paciente c ON (a.nr_atend_rn = c.nr_atendimento)
WHERE a.nr_atendimento = b.nr_atendimento  and b.cd_estabelecimento = d.cd_estabelecimento and a.nr_atendimento = nr_atendimento_w 	--3386549
  and a.nr_sequencia = nr_sequencia_w;	--1
c01_w	c01%rowtype;



BEGIN
intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);

begin
select	a.nr_seq_documento
into STRICT	nr_seq_documento_w
from	intpd_fila_transmissao a	
where	a.nr_sequencia		 = nr_seq_fila_p;
exception
when others then
	null;
end;

nr_atendimento_w			:= 	obter_valor_campo_separador(nr_seq_documento_w, 1, current_setting('ish_rzv_birth_pck.ds_separador_w')::varchar(15));
nr_sequencia_w			:= 	obter_valor_campo_separador(nr_seq_documento_w, 2, current_setting('ish_rzv_birth_pck.ds_separador_w')::varchar(15));

reg_integracao_w.nm_elemento	:= '_-rzvish_-caseModifyBirth';

open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	begin
	select	nr_episodio
	into STRICT	nr_episodio_w
	from	episodio_paciente
	where	nr_sequencia = c01_w.nr_seq_episodio;	
	exception
	when others then
		nr_episodio_w	:= 	null;
	end;
	
	begin
	select	nr_episodio
	into STRICT	nr_episodio_rn_w
	from	episodio_paciente
	where	nr_sequencia = c01_w.nr_seq_episodio_rn;	
	exception
	when others then
		nr_episodio_rn_w	:= 	null;
	end;
	
	reg_integracao_w.nm_tabela	:= 'ESTABELECIMENTO';
	intpd_processar_atrib_envio(reg_integracao_w, 'CD_EMPRESA', 'client', 'N', c01_w.cd_empresa, 'S', r_case_modify_birth_w.client);
	intpd_processar_atrib_envio(reg_integracao_w, 'CD_ESTABELECIMENTO', 'institution', 'N', c01_w.cd_estabelecimento, 'S', r_case_modify_birth_w.institution);
	
	reg_integracao_w.nm_tabela	:= 'EPISODIO_PACIENTE';
	intpd_processar_atrib_envio(reg_integracao_w, 'NR_EPISODIO', 'patcaseid1', 'N', nr_episodio_w, 'N', r_case_modify_birth_w.patcaseid1);
	intpd_processar_atrib_envio(reg_integracao_w, 'NR_EPISODIO', 'patcaseid2', 'N', nr_episodio_rn_w, 'N', r_case_modify_birth_w.patcaseid2);
	RETURN NEXT r_case_modify_birth_w;
	end;
end loop;
close c01;

CALL intpd_gravar_log_fila(reg_integracao_w);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_rzv_birth_pck.get_case_modify_birth (nr_seq_fila_p bigint) FROM PUBLIC;
