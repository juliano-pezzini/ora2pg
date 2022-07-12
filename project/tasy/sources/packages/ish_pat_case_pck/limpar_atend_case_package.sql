-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ish_pat_case_pck.limpar_atend_case ( nr_seq_fila_p bigint, nr_seq_episodio_p bigint, nr_seq_regra_conv_p bigint) AS $body$
DECLARE


ds_erro_w	varchar(4000);
qt_erro_w	bigint;
nr_seq_atepacu_w	bigint;
nr_seq_interno_w	bigint;
nr_atendimento_w	bigint;

c01 CURSOR FOR
SELECT	nr_atendimento
from	atendimento_paciente
where	nr_seq_episodio = nr_seq_episodio_p;

c02 CURSOR FOR
SELECT	nr_seq_interno
from	atend_categoria_convenio
where	nr_atendimento  = nr_atendimento_w;

c03 CURSOR FOR
SELECT	nr_seq_interno cd_interno,
	'ATEND_PACIENTE_UNIDADE' nm_tabela,
	'NR_SEQ_INTERNO' nm_atributo
from	atend_paciente_unidade
where	nr_atendimento = nr_atendimento_w

union all

select	nr_seq_interno,
	'ATEND_CATEGORIA_CONVENIO' nm_tabela,
	'NR_SEQ_INTERNO' nm_atributo
from	atend_categoria_convenio
where	nr_atendimento = nr_atendimento_w

union all

select	nr_seq_interno,
	'DIAGNOSTICO_DOENCA' nm_tabela,
	'NR_SEQ_INTERNO' nm_atributo
from	diagnostico_doenca
where	nr_atendimento = nr_atendimento_w

union all

select	nr_sequencia,
	'PROCEDIMENTO_PACIENTE' nm_tabela,
	'NR_SEQUENCIA' nm_atributo
from	procedimento_paciente
where	nr_atendimento = nr_atendimento_w

union all

select	nr_sequencia,
	'ATENDIMENTO_PACIENTE_INF' nm_tabela,
	'NR_SEQUENCIA' nm_atributo
from	atendimento_paciente_inf
where	nr_atendimento = nr_atendimento_w;

c03_w	c03%rowtype;


BEGIN

begin
CALL wheb_usuario_pck.set_ie_commit('N');

open c01;
loop
fetch c01 into
	nr_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	delete	FROM DANKIA_DISP_ATEND_PACIENTE
	where	nr_atendimento = nr_atendimento_w;

	delete	FROM CTA_PENDENCIA
	where	nr_atendimento = nr_atendimento_w;

	delete	FROM W_PAN_INFO_ADICIONAL
	where	nr_atendimento = nr_atendimento_w;	

	update	unidade_atendimento
	set	nr_atendimento	 = NULL
	where	nr_atendimento	=	nr_atendimento_w;

	open C02;
	loop
	fetch C02 into
		nr_seq_interno_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		delete	FROM atend_categoria_convenio
		where	nr_seq_interno	= nr_seq_interno_w
		and	nr_atendimento	= nr_atendimento_w;		
	end loop;
	close C02;	
	
	open C03;
	loop
	fetch C03 into	
		c03_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		delete	FROM conversao_meio_externo
		where	nr_seq_regra	= nr_seq_regra_conv_p
		and	nm_tabela	= c03_w.nm_tabela
		and	nm_atributo	= c03_w.nm_atributo
		and	somente_numero(cd_interno) = c03_w.cd_interno;
		end;
	end loop;
	close C03;
	
	excluir_atendimento(nr_atendimento_w, 'N', current_setting('ish_pat_case_pck.usernametasy')::varchar(15), null, ds_erro_w);

	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(obter_desc_expressao(783146) || ':' || nr_seq_episodio_p || ' ' ||
			obter_desc_expressao(722643) || ':' || nr_atendimento_w || chr(10) || chr(13) || ds_erro_w);
	end if;
	end;
end loop;
close c01;

delete  FROM episodio_paciente
where   nr_sequencia    = nr_seq_episodio_p;

CALL wheb_usuario_pck.set_ie_commit('S');
exception
when others then
	CALL wheb_usuario_pck.set_ie_commit('S');	
	CALL wheb_mensagem_pck.exibir_mensagem_abort(sqlerrm);
end;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ish_pat_case_pck.limpar_atend_case ( nr_seq_fila_p bigint, nr_seq_episodio_p bigint, nr_seq_regra_conv_p bigint) FROM PUBLIC;
