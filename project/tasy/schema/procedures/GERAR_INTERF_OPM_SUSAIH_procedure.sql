-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_interf_opm_susaih ( nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_sequencia_w			bigint;
cd_procedimento_opm_w		bigint;
ie_origem_proced_w		bigint;
nr_linha_proc_w			varchar(3);
nr_registro_anvisa_w		varchar(20);
nr_serie_w			varchar(20);
nr_lote_w			varchar(20);
nr_nota_fiscal_w		numeric(20);
cd_cgc_fornecedor_w		varchar(14);
cd_cgc_fabricante_w		varchar(14);
nr_aih_w			bigint;
ds_registro_w			varchar(1210);
qt_registro_w			smallint	:= 0;
nr_seq_reg_opm_w		smallint	:= 1;
ie_exp_cnpj_fornec_fabric_w	varchar(1)	:= coalesce(sus_obter_parametro_aih('IE_EXP_CNPJ_FORNEC_FABRIC', obter_estab_conta_paciente(nr_interno_conta_p)),'N');
cd_cgc_prestador_exp_w		varchar(14);
cd_estabelecimento_w		smallint;
ie_limpar_fabricante_w		varchar(15) := 'N';
dt_procedimento_w	procedimento_paciente.dt_procedimento%type;

/* Obter OPM's da AIH, máximo 10*/

C01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.cd_procedimento cd_procedimento_opm,
	a.ie_origem_proced,
	coalesce(b.nr_reg_anvisa,' ') nr_registro_anvisa,
	coalesce(b.nr_serie,' ') nr_serie,
	coalesce(b.nr_lote,' ') nr_lote,
	coalesce(b.nr_nota_fiscal,0) nr_nota_fiscal,
	coalesce(a.cd_cgc_prestador,' ') cd_cgc_fornecedor,
	coalesce(b.cd_cgc_fabricante,' ') cd_cgc_fabricante,
	a.dt_procedimento
from	sus_aih_opm		b,
	procedimento_paciente	a
where	a.nr_sequencia		= b.nr_seq_procedimento
and	nr_interno_conta	= nr_interno_conta_p
and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
order by cd_procedimento desc;

type 		fetch_array is table of c01%rowtype;
s_array 	fetch_array;
i		integer := 1;
type vetor is table of fetch_array index by integer;
vetor_c01_w			vetor;

BEGIN

begin
select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	conta_paciente
where	nr_interno_conta = nr_interno_conta_p  LIMIT 1;
exception
when others then
	cd_estabelecimento_w := 0;
end;

open c01;
loop
fetch c01 bulk collect into s_array limit 1000;
	vetor_c01_w(i) := s_array;
	i := i + 1;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

for i in 1..vetor_c01_w.count loop
	begin
	s_array := vetor_c01_w(i);
	for z in 1..s_array.count loop
		begin
		nr_sequencia_w		:= s_array[z].nr_sequencia;
		cd_procedimento_opm_w	:= s_array[z].cd_procedimento_opm;
		ie_origem_proced_w	:= s_array[z].ie_origem_proced;
		nr_registro_anvisa_w	:= s_array[z].nr_registro_anvisa;
		nr_serie_w		:= s_array[z].nr_serie;
		nr_lote_w		:= s_array[z].nr_lote;
		nr_nota_fiscal_w	:= s_array[z].nr_nota_fiscal;
		cd_cgc_fornecedor_w	:= s_array[z].cd_cgc_fornecedor;
		cd_cgc_fabricante_w	:= s_array[z].cd_cgc_fabricante;
		dt_procedimento_w := s_array[z].dt_procedimento;
		
		cd_cgc_prestador_exp_w := sus_obter_prest_exp(cd_procedimento_opm_w, ie_origem_proced_w, cd_cgc_fornecedor_w, cd_estabelecimento_w, 'S', 'N', 'N', cd_cgc_prestador_exp_w);
		
		if (cd_cgc_prestador_exp_w IS NOT NULL AND cd_cgc_prestador_exp_w::text <> '') then
			cd_cgc_fornecedor_w	:= cd_cgc_prestador_exp_w;
		end if;
		
		if (ie_exp_cnpj_fornec_fabric_w = 'S') then
			cd_cgc_fornecedor_w :=  cd_cgc_fabricante_w;			

			ie_limpar_fabricante_w := coalesce(obter_valor_param_usuario(1123, 195, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N');

			if (ie_limpar_fabricante_w = 'S') then
				cd_cgc_fabricante_w := '';
			end if;
		end if;
		
		/* +index (a PROPACI_CONPACI_I)  * Coloquei o teste da regra aqui pois quando estava na restrição do select do Cursor, estava ocasionando lentidão em alguns clientes*/

		if (sus_validar_regra(4, cd_procedimento_opm_w, ie_origem_proced_w,dt_procedimento_w) > 0) then
			/* Flag de controle da quantidade de registros */

			qt_registro_w	:= qt_registro_w + 1;

			begin
			select	max(nr_linha_proc)
			into STRICT	nr_linha_proc_w
			from	w_susaih_interf_item
			where	nr_seq_proc		= nr_sequencia_w
			and	nr_interno_conta	= nr_interno_conta_p;
			exception
				when others then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(207051,'NR_INTERNO_CONTA_P='||nr_interno_conta_p||';DS_ERRO_P='||sqlerrm);
				/*Conta:  || nr_interno_conta_p || - Erro: || sqlerrm*/

			end;
			
			nr_linha_proc_w	:= lpad(nr_linha_proc_w,3,'0');
			
			ds_registro_w	:= 	ds_registro_w || lpad(cd_procedimento_opm_w,10,0) || lpad(nr_linha_proc_w,3,0) || lpad(nr_registro_anvisa_w,20,' ') || 
						lpad(nr_serie_w,20,' ') || lpad(nr_lote_w,20,' ') || lpad(nr_nota_fiscal_w,20,0) || lpad(cd_cgc_fornecedor_w,14,' ') ||
						lpad(coalesce(cd_cgc_fabricante_w,' '),14,' ');
			
			/* Obter a sequence da tabela*/

			select	nextval('w_susaih_interf_opm_seq')
			into STRICT	nr_sequencia_w
			;
			
			insert into w_susaih_interf_opm(
				nr_sequencia,
				cd_procedimento_opm,
				ie_origem_proced,
				nr_linha_proc,
				nr_registro_anvisa,
				nr_serie,
				nr_lote,
				nr_nota_fiscal,
				cd_cgc_fornecedor,
				cd_cgc_fabricante,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_aih,
				nr_interno_conta,
				ds_registro_opm,
				nr_seq_reg_opm)
			values (	nr_sequencia_w,
				cd_procedimento_opm_w,
				ie_origem_proced_w,
				nr_linha_proc_w,
				nr_registro_anvisa_w,
				nr_serie_w,
				nr_lote_w,
				nr_nota_fiscal_w,
				cd_cgc_fornecedor_w,
				cd_cgc_fabricante_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_aih_w,
				nr_interno_conta_p,
				ds_registro_w,
				nr_seq_reg_opm_w);

			update	w_susaih_interf_opm
			set	ds_registro_opm		= rpad(ds_registro_w,1210,0)
			where	nr_interno_conta	= nr_interno_conta_p
			and	nr_seq_reg_opm		= nr_seq_reg_opm_w;

			if (qt_registro_w	= 10) then
				qt_registro_w		:= 0;
				ds_registro_w		:= '';
				nr_seq_reg_opm_w	:= nr_seq_reg_opm_w + 1;
			end if;	
		end if;
	
		end;
	end loop;
	end;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_interf_opm_susaih ( nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;

