-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eis_contas_prazo ( cd_convenios_p text, cd_categorias_p text, ie_tipos_atendimento_p text, nm_usuario_p text) AS $body$
DECLARE

			 
nr_atendimento_w			bigint;
nr_interno_conta_w			bigint;
cd_pessoa_fisica_w		varchar(10);
cd_convenio_w			integer;
cd_categoria_conv_w		varchar(10);
ie_tipo_atendimento_w		smallint;
nm_pessoa_fisica_w		varchar(60);
ds_convenio_w			varchar(255);
qt_dia_entrega_w			bigint;
vl_conta_w			double precision;			
ie_insere_w			varchar(1) := 'S';
			
C01 CURSOR FOR 
	SELECT	a.nr_atendimento, 
		b.nr_interno_conta, 
		a.cd_pessoa_fisica, 
		b.cd_convenio_parametro, 
		b.cd_categoria_parametro, 
		a.ie_tipo_atendimento 
	from	conta_paciente b, 
		atendimento_paciente a 
	where	a.nr_atendimento = b.nr_atendimento 
	and	eis_obter_dt_regra_prazo_conta(b.nr_interno_conta,'PL') <= trunc(clock_timestamp()) 
	and not exists (SELECT	1 
			from	titulo_receber x 
			where	x.nr_interno_conta = b.nr_interno_conta) 
	and not exists (select	1 
			from	titulo_receber x 
			where	x.nr_seq_protocolo = b.nr_seq_protocolo) 
	and not exists (select	1 
			from	nota_fiscal x 
			where	x.nr_interno_conta = b.nr_interno_conta) 
	and not exists (select	1 
			from	nota_fiscal x 
			where	x.nr_seq_protocolo = b.nr_seq_protocolo) 
	and	((coalesce(cd_convenios_p::text, '') = '') 
		or (obter_se_contido(b.cd_convenio_parametro,substr(cd_convenios_p,2,length(cd_convenios_p))) = substr(cd_convenios_p,1,1))) 
	order by a.cd_pessoa_fisica;
	
TYPE		fetch_array IS TABLE OF c01%ROWTYPE;
s_array 	fetch_array;
i		integer := 1;
type Vetor is table of fetch_array index by integer;
Vetor_c01_w			Vetor;

BEGIN 
 
delete from w_eis_conta_pendente_prazo a where a.nm_usuario = nm_usuario_p;
commit;
 
open C01;
loop 
fetch C01 bulk collect into s_array limit 1000;
	Vetor_c01_w(i) := s_array;
	i := i + 1;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;
 
for i in 1..Vetor_c01_w.COUNT loop 
	s_array := Vetor_c01_w(i);
	for z in 1..s_array.COUNT loop 
	begin 
	nr_atendimento_w		:= s_array[z].nr_atendimento;
	nr_interno_conta_w		:= s_array[z].nr_interno_conta;
	cd_pessoa_fisica_w		:= s_array[z].cd_pessoa_fisica;
	cd_convenio_w			:= s_array[z].cd_convenio_parametro;
	cd_categoria_conv_w		:= s_array[z].cd_categoria_parametro;
	ie_tipo_atendimento_w		:= s_array[z].ie_tipo_atendimento;
	ie_insere_w			:= 'S';
	 
	if (cd_categorias_p IS NOT NULL AND cd_categorias_p::text <> '') and (obter_se_contido_char(replace(cd_convenio_w||cd_categoria_conv_w,' ',''),replace(substr(cd_categorias_p,2,length(cd_categorias_p)),' ','')) <> substr(cd_categorias_p,1,1)) then 
		ie_insere_w	:= 'N';
		goto final;
	end if;
	 
	if (ie_tipos_atendimento_p IS NOT NULL AND ie_tipos_atendimento_p::text <> '') and (obter_se_contido(ie_tipo_atendimento_w, substr(ie_tipos_atendimento_p,2,length(ie_tipos_atendimento_p))) <> substr(ie_tipos_atendimento_p,1,1)) then 
		ie_insere_w	:= 'N';
		goto final;
	end if;
	 
<<final>> 
	if (ie_insere_w = 'S') and (coalesce(nr_interno_conta_w,0) <> 0) then 
		begin 
		select	substr(obter_nome_pf(cd_pessoa_fisica_w),1,60), 
			substr(obter_desc_convenio(cd_convenio_parametro),1,255), 
			substr(obter_dias_entre_datas(eis_obter_dt_regra_prazo_conta(nr_interno_conta,'P'),clock_timestamp()),1,10), 
			obter_valor_conta(nr_interno_conta,0) 
		into STRICT	nm_pessoa_fisica_w, 
			ds_convenio_w, 
			qt_dia_entrega_w, 
			vl_conta_w 
		from	conta_paciente 
		where	nr_interno_conta = nr_interno_conta_w;
		 
		insert into w_eis_conta_pendente_prazo( 
						nr_sequencia, 
						dt_atualizacao, 
						nm_usuario, 
						dt_atualizacao_nrec, 
						nm_usuario_nrec, 
						nr_interno_conta, 
						nr_atendimento, 
						nm_paciente, 
						cd_convenio_conta, 
						ds_convenio_conta, 
						qt_dias_entrega, 
						vl_conta, 
						cd_pessoa_fisica) 
					values (	nextval('w_eis_conta_pendente_prazo_seq'), 
						clock_timestamp(), 
						nm_usuario_p, 
						clock_timestamp(), 
						nm_usuario_p, 
						nr_interno_conta_w, 
						nr_atendimento_w, 
						nm_pessoa_fisica_w, 
						cd_convenio_w, 
						ds_convenio_w, 
						qt_dia_entrega_w, 
						vl_conta_w, 
						cd_pessoa_fisica_w);
		end;
	end if;
	end;
	end loop;
	commit;
end loop;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eis_contas_prazo ( cd_convenios_p text, cd_categorias_p text, ie_tipos_atendimento_p text, nm_usuario_p text) FROM PUBLIC;
